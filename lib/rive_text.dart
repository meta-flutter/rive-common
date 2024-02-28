import 'dart:collection';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:rive_common/math.dart';

import 'src/rive_text_ffi.dart'
    if (dart.library.html) 'src/rive_text_wasm.dart';

export 'src/glyph_lookup.dart';

enum RawPathVerb { move, line, quad, cubic, close }

abstract class RawPathCommand {
  final RawPathVerb verb;
  RawPathCommand(this.verb);
  Vec2D point(int index);
}

abstract class RawPath with IterableMixin<RawPathCommand> {
  void dispose();
  void issueCommands(ui.Path path) {
    for (final command in this) {
      switch (command.verb) {
        case RawPathVerb.move:
          var p = command.point(0);
          path.moveTo(p.x, p.y);
          break;
        case RawPathVerb.line:
          var p = command.point(1);
          path.lineTo(p.x, p.y);
          break;
        case RawPathVerb.quad:
          var p1 = command.point(1);
          var p2 = command.point(2);
          path.quadraticBezierTo(p1.x, p1.y, p2.x, p2.y);

          break;
        case RawPathVerb.cubic:
          var p1 = command.point(1);
          var p2 = command.point(2);
          var p3 = command.point(3);
          path.cubicTo(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
          break;
        case RawPathVerb.close:
          path.close();
          break;
      }
    }
  }
}

enum TextDirection { ltr, rtl }

enum TextAlign { left, right, center }

abstract class Paragraph {
  TextDirection get direction;
  List<GlyphRun> get runs;
  List<GlyphRun> get logicalRuns => runs;

  List<GlyphRun> orderVisually(List<GlyphRun> glyphRuns) {
    if (direction == TextDirection.ltr) {
      return glyphRuns;
    }
    var visualOrder = <GlyphRun>[];
    if (glyphRuns.isNotEmpty) {
      var reversed = glyphRuns.reversed;
      GlyphRun previous = reversed.first;
      visualOrder.add(previous);
      int ltrIndex = 0;
      for (final run in reversed.skip(1)) {
        if (run.direction == TextDirection.ltr &&
            previous.direction == run.direction) {
          visualOrder.insert(ltrIndex, run);
        } else {
          if (run.direction == TextDirection.ltr) {
            ltrIndex = visualOrder.length;
          }
          visualOrder.add(run);
        }
        previous = run;
      }
    }
    return visualOrder;
  }

  List<GlyphRun> get visualRuns => orderVisually(runs);
}

abstract class GlyphRun {
  Font get font;
  double get fontSize;
  double get lineHeight;
  double get letterSpacing;
  int get styleId;
  int get glyphCount;
  TextDirection get direction;
  int glyphIdAt(int index);
  int textIndexAt(int index);
  double advanceAt(int index);
  Vec2D offsetAt(int index);
  double xAt(int index);
}

class LineRunGlyph {
  final GlyphRun run;
  final int index;

  LineRunGlyph(this.run, this.index);

  Float64List pathTransform(double x, double y) {
    var v = run.offsetAt(index);
    var scale = run.fontSize;
    return Float64List.fromList([
      scale,
      0.0,
      0.0,
      0.0,
      0.0,
      scale,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
      x + v.x,
      y + v.y,
      0.0,
      1.0
    ]);
  }

  Mat2D renderTransform(double x, double y) =>
      Mat2D.fromScaleAndTranslation(run.fontSize, run.fontSize, x, y);

  @override
  bool operator ==(Object other) =>
      other is LineRunGlyph && other.run == run && other.index == index;

  @override
  int get hashCode => Object.hash(run, index);

  // Compute the horizontal center of the glyph.
  double get center => run.advanceAt(index) / 2;

  Vec2D get offset => run.offsetAt(index);
}

abstract class GlyphLine {
  int get startRun;
  int get startIndex;
  int get endRun;
  int get endIndex;
  double get startX;
  double get top;
  double get baseline;
  double get bottom;

  double width(Paragraph paragraph) {
    var glyphRuns = paragraph.runs;
    var startGRun = glyphRuns[startRun];
    var endGRun = glyphRuns[endRun];
    return endGRun.xAt(endIndex) -
        startGRun.xAt(startIndex) -
        endGRun.letterSpacing;
  }

  /// Returns an iterator that traverses the glyphs in a line in visual order
  /// taking into account both the paragraph's runs bidi order and the
  /// individual glyphs bidi order within a run.
  Iterable<LineRunGlyph> glyphs(Paragraph paragraph) sync* {
    var displayRuns = <GlyphRun>[];
    var glyphRuns = paragraph.runs;

    for (int i = startRun; i < endRun + 1; i++) {
      displayRuns.add(glyphRuns[i]);
    }

    var startRunRef = displayRuns.first;
    var endRunRef = displayRuns.last;

    var visualRuns = paragraph.orderVisually(displayRuns);

    for (final run in visualRuns) {
      int startGIndex = startRunRef == run ? startIndex : 0;
      int endGIndex = endRunRef == run ? endIndex : run.glyphCount;

      int j, end, inc;
      if (run.direction == TextDirection.rtl) {
        j = endGIndex - 1;
        end = startGIndex - 1;
        inc = -1;
      } else {
        j = startGIndex;
        end = endGIndex;
        inc = 1;
      }

      while (j != end) {
        yield LineRunGlyph(run, j);
        j += inc;
      }
    }
  }

  Iterable<LineRunGlyph> glyphsWithEllipsis(
    double width, {
    required Paragraph paragraph,
    required List<TextShapeResult> cleanupShapes,
    String ellipsis = '...',
    bool isLastLine = false,
  }) sync* {
    var displayRuns = <GlyphRun>[];
    // Iterate in logical order to add ellipsis at overflow.
    var glyphRuns = paragraph.runs;
    Font? ellipsisFont;
    TextShapeResult? ellipsisShape;
    GlyphRun? ellipsisRun;
    double ellipsisWidth = 0;
    double x = 0;
    double ellipsisFontSize = 0;
    int startGIndex = startIndex;
    GlyphRun? endRunRef;
    bool addedEllipsis = false;

    var actualEndIndex = endIndex;
    // If it's the last line we can actually early out if the whole things fits,
    // so check that first with no extra shaping.
    if (isLastLine) {
      bool fits = true;
      measuringLastLine:
      for (int i = startRun; i < endRun + 1; i++) {
        var run = glyphRuns[i];
        int endGIndex = i == endRun ? endIndex : run.glyphCount;

        for (int j = startGIndex; j != endGIndex; j++) {
          x += run.advanceAt(j);
          if (x > width) {
            fits = false;
            break measuringLastLine;
          }
        }
        startGIndex = 0;
      }
      if (fits) {
        // It fits, just get the regular glyphs.
        yield* glyphs(paragraph);
        return;
      }
    }
    startGIndex = startIndex;
    for (int i = startRun; i < endRun + 1; i++) {
      var run = glyphRuns[i];
      if (run.font != ellipsisFont && run.fontSize != ellipsisFontSize) {
        // Track the latest we've checked (even if we discard it so we don't try
        // to do this again for this ellipsis).
        ellipsisFont = run.font;
        ellipsisFontSize = run.fontSize;

        // Get the next shape so we can check if it fits, otherwise keep using
        // the last one.
        var nextEllipsisShape = run.font.shape(
          '...',
          [
            TextRun(
              font: run.font,
              fontSize: run.fontSize,
              unicharCount: 3,
            ),
          ],
        );
        // Hard assumption one run and para
        var para = nextEllipsisShape.paragraphs.first;
        var nextEllipsisRun = para.runs.first;

        double nextEllipsisWidth = 0;
        for (int j = 0; j < nextEllipsisRun.glyphCount; j++) {
          nextEllipsisWidth += nextEllipsisRun.advanceAt(j);
        }

        if (ellipsisShape == null || x + nextEllipsisWidth <= width) {
          // This ellipsis still fits, go ahead and use it. Otherwise stick with
          // the old one.
          ellipsisWidth = nextEllipsisWidth;
          ellipsisRun = nextEllipsisRun;
          ellipsisShape?.dispose();
          ellipsisShape = nextEllipsisShape;
        }
      }

      int endGIndex = i == endRun ? endIndex : run.glyphCount;
      for (int j = startGIndex; j != endGIndex; j++) {
        var advance = run.advanceAt(j);
        if (x + advance + ellipsisWidth > width) {
          actualEndIndex = j;
          addedEllipsis = true;
          break;
        }
        x += advance;
      }
      endRunRef = run;
      startGIndex = 0;
      displayRuns.add(run);
      if (addedEllipsis) {
        if (ellipsisRun != null) {
          displayRuns.add(ellipsisRun);
        }
        break;
      }
    }

    // There was enough space for it, so let's add the ellipsis. Note that we
    // already checked if this is the last line and found that the whole text
    // didn't fit.
    if (!addedEllipsis && ellipsisRun != null) {
      displayRuns.add(ellipsisRun);
    }
    var startRunRef =
        ellipsisRun == displayRuns.first ? null : displayRuns.first;

    for (final run in paragraph.orderVisually(displayRuns)) {
      int startGIndex = startRunRef == run ? startIndex : 0;
      int endGIndex = endRunRef == run ? actualEndIndex : run.glyphCount;
      int j, end, inc;
      if (run.direction == TextDirection.rtl) {
        j = endGIndex - 1;
        end = startGIndex - 1;
        inc = -1;
      } else {
        j = startGIndex;
        end = endGIndex;
        inc = 1;
      }

      while (j != end) {
        yield LineRunGlyph(run, j);
        j += inc;
      }
    }
    if (ellipsisShape != null) {
      cleanupShapes.add(ellipsisShape);
    }
  }
}

abstract class BreakLinesResult extends ListBase<List<GlyphLine>> {
  void dispose();
}

abstract class TextShapeResult {
  List<Paragraph> get paragraphs;
  void dispose();
  BreakLinesResult breakLines(double width, TextAlign alignment);
}

/// A representation of a styled section of text in Rive.
class TextRun {
  final Font font;
  final double fontSize;
  final double lineHeight;
  final double letterSpacing;
  final int unicharCount;
  final int styleId;
  final Object? userData;

  TextRun({
    required this.font,
    required this.fontSize,
    required this.unicharCount,
    this.lineHeight = -1.0,
    this.letterSpacing = 0,
    this.styleId = 0,
    this.userData,
  });

  TextRun copyWith({
    int? unicharCount,
    int? styleId,
    Object? userData,
    Font? font,
    double? fontSize,
    double? lineHeight,
    double? letterSpacing,
  }) =>
      TextRun(
        font: font ?? this.font,
        fontSize: fontSize ?? this.fontSize,
        lineHeight: lineHeight ?? this.lineHeight,
        letterSpacing: letterSpacing ?? this.letterSpacing,
        unicharCount: unicharCount ?? this.unicharCount,
        styleId: styleId ?? this.styleId,
        userData: userData ?? this.userData,
      );

  @override
  String toString() => 'TextRun($fontSize:$unicharCount:$styleId)';

  @override
  bool operator ==(Object other) =>
      other is TextRun &&
      other.font == font &&
      other.fontSize == fontSize &&
      other.unicharCount == unicharCount &&
      other.styleId == styleId &&
      other.userData == userData;

  @override
  int get hashCode => Object.hash(font, fontSize, unicharCount, styleId);
}

abstract class FontTag {
  int get tag;
  static String tagToName(int tag) => String.fromCharCodes(
        [
          tag >> 24,
          (tag >> 16) & 0xFF,
          (tag >> 8) & 0xFF,
          tag & 0xFF,
        ],
      );

  static int nameToTag(String name) {
    final codeUnits = name.codeUnits;
    return codeUnits[0] << 24 |
        codeUnits[1] << 16 |
        codeUnits[2] << 8 |
        codeUnits[3];
  }
}

abstract class FontAxis extends FontTag {
  double get min;
  double get def;
  double get max;
  String get name;

  FontAxisCoord valueAt(double value);
}

class FontAxisCoord {
  final int tag;
  final double value;

  FontAxisCoord(this.tag, this.value);
}

class FontFeature {
  final int tag;
  final int value;

  FontFeature(this.tag, this.value);
}

abstract class Font {
  // Variable axes available to the font.
  Iterable<FontAxis> get axes;
  // Features available to the font.
  Iterable<FontTag> get features;

  double axisValue(int axisTag);
  static bool _initialized = false;
  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    return initFont();
  }

  static Font? decode(Uint8List bytes) {
    return decodeFont(bytes);
  }

  double get ascent;
  double get descent;

  double lineHeight(double fontSize) => (-ascent + descent) * fontSize;

  static void setFallbacks(List<Font> fonts) {
    setFallbackFonts(fonts);
  }

  RawPath getPath(int glyphId);
  void dispose();

  TextShapeResult shape(String text, List<TextRun> runs);

  final HashMap<int, ui.Path> _glyphPaths = HashMap<int, ui.Path>();
  ui.Path getUiPath(int glyphId) {
    var glyphPath = _glyphPaths[glyphId];
    if (glyphPath != null) {
      return glyphPath;
    }
    var path = ui.Path();
    var rawPath = getPath(glyphId);
    rawPath.issueCommands(path);
    rawPath.dispose();
    _glyphPaths[glyphId] = path;
    return path;
  }

  Font? withOptions(
    Iterable<FontAxisCoord> coords,
    Iterable<FontFeature> features,
  );
}
