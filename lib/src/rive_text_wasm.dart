// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:collection';
import 'dart:js_interop' as js;
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:rive_common/math.dart';
import 'package:rive_common/rive_text.dart';
import 'package:rive_common/src/layout_engine_wasm.dart';
import 'package:rive_common/src/rive_audio_wasm.dart';
import 'package:rive_common/src/rive_text_wasm_version.dart';
import 'package:rive_common/utilities.dart';
import 'package:web/web.dart' as html;

late js.JSFunction _makeFont;
late js.JSFunction _fontAxis;
late js.JSFunction _fontAxisCount;
late js.JSFunction _fontAxisValue;
late js.JSFunction _makeFontWithOptions;
late js.JSFunction _deleteFont;
late js.JSFunction _makeGlyphPath;
late js.JSFunction _deleteGlyphPath;
late js.JSFunction _shapeText;
late js.JSFunction _setFallbackFonts;
late js.JSFunction _deleteShapeResult;
late js.JSFunction _breakLines;
late js.JSFunction _deleteLines;
late js.JSFunction _fontFeatures;
late js.JSFunction _fontAscent;
late js.JSFunction _fontDescent;
late js.JSFunction _disableFallbackFonts;
late js.JSFunction _enableFallbackFonts;

class RawPathWasm extends RawPath {
  final Uint8List verbs;
  final Float32List points;

  RawPathWasm({
    required this.verbs,
    required this.points,
  });

  @override
  void dispose() {}

  @override
  Iterator<RawPathCommand> get iterator => RawPathIterator._(verbs, points);
}

class RawPathCommandWasm extends RawPathCommand {
  final Float32List _points;
  final int _pointsOffset;

  RawPathCommandWasm._(
    RawPathVerb verb,
    this._points,
    this._pointsOffset,
  ) : super(verb);

  @override
  Vec2D point(int index) {
    var base = _pointsOffset + index * 2;
    return Vec2D.fromValues(_points[base], _points[base + 1]);
  }
}

RawPathVerb _verbFromNative(int nativeVerb) {
  switch (nativeVerb) {
    case 0:
      return RawPathVerb.move;
    case 1:
      return RawPathVerb.line;
    case 2:
      return RawPathVerb.quad;
    case 4:
      return RawPathVerb.cubic;
    case 5:
      return RawPathVerb.close;
    default:
      throw Exception('Unexpected nativeVerb: $nativeVerb');
  }
}

int _ptsAdvanceAfterVerb(RawPathVerb verb) {
  switch (verb) {
    case RawPathVerb.move:
      return 1;
    case RawPathVerb.line:
      return 1;
    case RawPathVerb.quad:
      return 2;
    case RawPathVerb.cubic:
      return 3;
    case RawPathVerb.close:
      return 0;
    default:
      throw Exception('Unexpected nativeVerb: $verb');
  }
}

int _ptsBacksetForVerb(RawPathVerb verb) {
  switch (verb) {
    case RawPathVerb.move:
      return 0;
    case RawPathVerb.line:
      return -1;
    case RawPathVerb.quad:
      return -1;
    case RawPathVerb.cubic:
      return -1;
    case RawPathVerb.close:
      return -1;
    default:
      throw Exception('Unexpected nativeVerb: $verb');
  }
}

class RawPathIterator implements Iterator<RawPathCommand> {
  final Uint8List verbs;
  final Float32List points;
  int _verbIndex = -1;
  int _ptIndex = -1;

  RawPathVerb _verb = RawPathVerb.move;

  RawPathIterator._(this.verbs, this.points);

  @override
  RawPathCommand get current => RawPathCommandWasm._(
        _verb,
        points,
        (_ptIndex + _ptsBacksetForVerb(_verb)) * 2,
      );

  @override
  bool moveNext() {
    if (++_verbIndex < verbs.length) {
      _ptIndex += _ptsAdvanceAfterVerb(_verb);
      _verb = _verbFromNative(verbs[_verbIndex]);
      return true;
    }
    return false;
  }
}

class GlyphLineWasm extends GlyphLine {
  @override
  final int startRun;

  @override
  final int startIndex;

  @override
  final int endRun;

  @override
  final int endIndex;

  @override
  final double startX;

  @override
  final double top;

  @override
  final double baseline;

  @override
  final double bottom;

  GlyphLineWasm(ByteData data)
      : startRun = data.getUint32(0, Endian.little),
        startIndex = data.getUint32(4, Endian.little),
        endRun = data.getUint32(8, Endian.little),
        endIndex = data.getUint32(12, Endian.little),
        startX = data.getFloat32(16, Endian.little),
        top = data.getFloat32(20, Endian.little),
        baseline = data.getFloat32(24, Endian.little),
        bottom = data.getFloat32(28, Endian.little);

  @override
  String toString() {
    return '''GlyphLineWasm $startRun $startIndex $endRun $endIndex $startX $top $baseline $bottom''';
  }
}

class BreakLinesResultFFI extends BreakLinesResult {
  final List<List<GlyphLine>> list;
  BreakLinesResultFFI(this.list);
  @override
  int get length => list.length;

  @override
  set length(int value) => list.length = value;

  @override
  List<GlyphLine> operator [](int index) => list[index];

  @override
  void operator []=(int index, List<GlyphLine> value) => list[index] = value;

  @override
  void dispose() {}
}

class TextShapeResultWasm extends TextShapeResult {
  static final _finalizer = Finalizer<js.JSAny>(
    (ptr) => _deleteShapeResult.callAsFunction(
      null,
      ptr,
    ),
  );
  int _shapeResultPtr;
  int get shapeResultPtr => _shapeResultPtr;

  @override
  final List<ParagraphWasm> paragraphs;

  TextShapeResultWasm(this._shapeResultPtr, this.paragraphs) {
    _finalizer.attach(this, shapeResultPtr.toJS, detach: this);
  }

  @override
  void dispose() {
    _finalizer.detach(this);
    _deleteShapeResult.callAsFunction(null, _shapeResultPtr.toJS);
    _shapeResultPtr = 0;
  }

  @override
  BreakLinesResult breakLines(double width, TextAlign alignment) {
    var result = _breakLines.callAsFunction(
      null,
      shapeResultPtr.toJS,
      width.toJS,
      alignment.index.toJS,
    ) as js.JSObject;

    var rawResult = (result['rawResult'] as js.JSNumber).toDartInt;
    var results = (result['results'] as js.JSUint8Array).toDart;

    const lineSize = 32;
    var paragraphsList = ByteData.view(results.buffer, results.offsetInBytes)
        .readDynamicArray(0);
    var paragraphsLines = <List<GlyphLine>>[];
    var pointerEnd = paragraphsList.size * 8;
    for (var pointer = 0; pointer < pointerEnd; pointer += 8) {
      var sublist = paragraphsList.data.readDynamicArray(pointer);
      var lines = <GlyphLine>[];

      var end = sublist.data.offsetInBytes + sublist.size * lineSize;
      for (var lineOffset = sublist.data.offsetInBytes;
          lineOffset < end;
          lineOffset += lineSize) {
        lines.add(
          GlyphLineWasm(
            ByteData.view(
              sublist.data.buffer,
              lineOffset,
            ),
          ),
        );
      }
      paragraphsLines.add(lines);
    }
    _deleteLines.callAsFunction(
      null,
      rawResult.toJS,
    );

    return BreakLinesResultFFI(paragraphsLines);
  }
}

extension ByteDataWasm on ByteData {
  WasmDynamicArray readDynamicArray(int offset) {
    return WasmDynamicArray(
      ByteData.view(buffer, getUint32(offset, Endian.little)),
      getUint32(
        offset + 4,
        Endian.little,
      ),
    );
  }

  Uint16List readUint16List(int offset, {bool clone = true}) {
    var array = readDynamicArray(offset);
    var list =
        array.data.buffer.asUint16List(array.data.offsetInBytes, array.size);
    if (clone) {
      return Uint16List.fromList(list);
    }
    return list;
  }

  Uint32List readUint32List(int offset, {bool clone = true}) {
    var array = readDynamicArray(offset);
    var list =
        array.data.buffer.asUint32List(array.data.offsetInBytes, array.size);
    if (clone) {
      return Uint32List.fromList(list);
    }
    return list;
  }

  Float32List readFloat32List(int offset, {bool clone = true}) {
    var array = readDynamicArray(offset);
    var list =
        array.data.buffer.asFloat32List(array.data.offsetInBytes, array.size);

    if (clone) {
      return Float32List.fromList(list);
    }
    return list;
  }

  Float32List readVec2DList(int offset, {bool clone = true}) {
    var array = readDynamicArray(offset);
    var list = array.data.buffer
        .asFloat32List(array.data.offsetInBytes, array.size * 2);

    if (clone) {
      return Float32List.fromList(list);
    }
    return list;
  }
}

class WasmDynamicArray {
  final ByteData data;
  final int size;
  WasmDynamicArray(this.data, this.size);
}

class LinesWasm extends ListBase<GlyphLineWasm> {
  final WasmDynamicArray wasmDynamicArray;

  LinesWasm(this.wasmDynamicArray);

  @override
  int get length => wasmDynamicArray.size;

  @override
  GlyphLineWasm operator [](int index) {
    const lineSize = 4 + //startRun
        4 + // startIndex
        4 + // endRun
        4 + // endIndex
        4 + // startX
        4 + // top
        4 + // baseline
        4; // bottom
    var data = wasmDynamicArray.data;
    return GlyphLineWasm(
      ByteData.view(
        data.buffer,
        data.offsetInBytes + index * lineSize,
      ),
    );
  }

  @override
  void operator []=(int index, GlyphLineWasm value) {
    throw UnsupportedError('Cannot set Line on LinesWasm array');
  }

  @override
  set length(int newLength) {
    throw UnsupportedError('Cannot set Line count on LinesWasm array');
  }
}

class ParagraphWasm extends Paragraph {
  final ByteData data;
  @override
  final TextDirection direction;

  @override
  final List<GlyphRunWasm> runs = [];

  ParagraphWasm(this.data)
      : direction = TextDirection.values[data.getUint8(8)] {
    const runSize =
        68; // see rive_text_bindings.cpp assertSomeAssumptions for explanation
    var runsPointer = data.getUint32(0, Endian.little);
    var runsCount = data.getUint32(4, Endian.little);

    for (int i = 0, runPointer = runsPointer;
        i < runsCount;
        i++, runPointer += runSize) {
      runs.add(GlyphRunWasm(ByteData.view(data.buffer, runPointer)));
    }
  }
}

class GlyphRunWasm extends GlyphRun {
  final ByteData byteData;
  final Uint16List glyphs;
  final Uint32List textIndices;
  final Float32List advances;
  final Float32List xPositions;
  final Float32List offsets;

  @override
  final TextDirection direction;

  @override
  final int styleId;

  @override
  final Font font;

  @override
  final double fontSize;

  @override
  final double lineHeight;

  @override
  final double letterSpacing;

  GlyphRunWasm(this.byteData)
      : font = FontWasm(byteData.getUint32(0, Endian.little)),
        fontSize = byteData.getFloat32(4, Endian.little),
        lineHeight = byteData.getFloat32(8, Endian.little),
        letterSpacing = byteData.getFloat32(12, Endian.little),
        glyphs = byteData.readUint16List(16),
        textIndices = byteData.readUint32List(24),
        advances = byteData.readFloat32List(32),
        xPositions = byteData.readFloat32List(40),
        offsets = byteData.readVec2DList(48),
        styleId = byteData.getUint16(64, Endian.little),
        direction = TextDirection.values[byteData.getUint8(66)];

  @override
  int get glyphCount => glyphs.length;

  @override
  int glyphIdAt(int index) => glyphs[index];

  @override
  int textIndexAt(int index) => textIndices[index];

  @override
  double advanceAt(int index) => advances[index];

  @override
  double xAt(int index) => xPositions[index];

  @override
  Vec2D offsetAt(int index) {
    var o = index * 2;
    return Vec2D.fromValues(offsets[o], offsets[o + 1]);
  }
}

/// A Font reference that should not be explicitly disposed by the user.
/// Returned while shaping.
class FontWasm extends Font {
  final int fontPtr;
  FontWasm(this.fontPtr);

  @override
  String toString() {
    return 'FontWasm $fontPtr';
  }

  @override
  void dispose() {}

  @override
  RawPath getPath(int glyphId) {
    var object = _makeGlyphPath.callAsFunction(null, fontPtr.toJS, glyphId.toJS)
        as js.JSObject;
    var rawPathPtr = (object['rawPath'] as js.JSNumber).toDartInt;

    // The buffer for these share the WASM heap buffer, which is efficient but
    // could also be lost in-between calls to WASM.
    var verbs = (object['verbs'] as js.JSUint8Array).toDart;
    var points = (object['points'] as js.JSFloat32Array).toDart;

    // We copy the verb and points structures so we don't have to worry about
    // the references being lost if the WASM heap is re-allocated.
    var rawPath = RawPathWasm(
      verbs: Uint8List.fromList(verbs),
      points: Float32List.fromList(points),
    );
    // Immediately delete the native glyph's raw path.
    _deleteGlyphPath.callAsFunction(null, rawPathPtr.toJS);
    return rawPath;
  }

  static const int sizeOfNativeTextRun = 28;

  @override
  TextShapeResult shape(String text, List<TextRun> runs) {
    var writer = BinaryWriter(
      alignment: runs.length * sizeOfNativeTextRun,
    );
    for (final run in runs) {
      writer.writeUint32((run.font as FontWasm).fontPtr);
      writer.writeFloat32(run.fontSize);
      writer.writeFloat32(run.lineHeight);
      writer.writeFloat32(run.letterSpacing);
      writer.writeUint32(run.unicharCount);
      writer.writeUint32(0); // script (unknown at this point)
      writer.writeUint16(run.styleId);
      writer.writeUint8(0); // dir (unknown at this point)
      writer.writeUint8(0); // padding to word align struct
    }

    var result = _shapeText.callAsFunction(
      null,
      Uint32List.fromList(text.codeUnits).toJS,
      writer.uint8Buffer.toJS,
    ) as js.JSObject;

    var rawResult = (result['rawResult'] as js.JSNumber).toDartInt;
    var results = (result['results'] as js.JSUint8Array).toDart;

    var reader = BinaryReader.fromList(results);
    var paragraphsPointer = reader.readUint32();
    var paragraphsSize = reader.readUint32();

    var paragraphList = <ParagraphWasm>[];
    const paragraphSize = 12; // runs = 8, direction = 1, padding = 3

    for (int i = 0;
        i < paragraphsSize;
        i++, paragraphsPointer += paragraphSize) {
      paragraphList
          .add(ParagraphWasm(ByteData.view(results.buffer, paragraphsPointer)));
    }

    return TextShapeResultWasm(rawResult, paragraphList);
  }

  @override
  Iterable<FontAxis> get axes => _FontAxisList(fontPtr);

  @override
  Iterable<FontTag> get features {
    var features =
        (_fontFeatures.callAsFunction(null, fontPtr.toJS) as js.JSArray).toDart;
    return features.map((value) => FontTagWasm(value as int));
  }

  @override
  double axisValue(int axisTag) =>
      (_fontAxisValue.callAsFunction(null, fontPtr.toJS, axisTag.toJS)
              as js.JSNumber)
          .toDartDouble;

  static const int sizeOfNativeAxisCoord = 8;

  @override
  Font? withOptions(
    Iterable<FontAxisCoord> coords,
    Iterable<FontFeature> features,
  ) {
    var coordsWriter = BinaryWriter(
      alignment: coords.length * sizeOfNativeAxisCoord,
    );
    for (final coord in coords) {
      coordsWriter.writeUint32(coord.tag);
      coordsWriter.writeFloat32(coord.value);
    }

    var featureWriter = BinaryWriter(
      alignment: coords.length * sizeOfNativeAxisCoord,
    );
    for (final feature in features) {
      featureWriter.writeUint32(feature.tag);
      featureWriter.writeUint32(feature.value);
    }

    var ptr = (_makeFontWithOptions.callAsFunction(
      null,
      fontPtr.toJS,
      coordsWriter.uint8Buffer.toJS,
      featureWriter.uint8Buffer.toJS,
    ) as js.JSNumber)
        .toDartInt;
    if (ptr == 0) {
      return null;
    }
    return StrongFontWasm(ptr);
  }

  @override
  double get ascent =>
      (_fontAscent.callAsFunction(null, fontPtr.toJS) as js.JSNumber)
          .toDartDouble;

  @override
  double get descent =>
      (_fontDescent.callAsFunction(null, fontPtr.toJS) as js.JSNumber)
          .toDartDouble;
}

class FontAxisWasm extends FontAxis {
  @override
  final double def;

  @override
  final double max;

  @override
  final double min;

  FontAxisWasm(this.tag, this.min, this.def, this.max);

  @override
  String get name => FontTag.tagToName(tag);

  @override
  final int tag;

  @override
  FontAxisCoord valueAt(double value) => FontAxisCoord(tag, value);
}

class FontTagWasm extends FontTag {
  @override
  final int tag;

  FontTagWasm(this.tag);

  @override
  String toString() => 'FontTagWasm($tag == ${FontTag.tagToName(tag)})';
}

class FontAxisIterator implements Iterator<FontAxis> {
  final int fontPtr;
  final int axisCount;
  int axisIndex = -1;

  FontAxisIterator(this.fontPtr)
      : axisCount =
            (_fontAxisCount.callAsFunction(null, fontPtr.toJS) as js.JSNumber)
                .toDartInt;

  @override
  FontAxis get current {
    var array = (_fontAxis.callAsFunction(null, fontPtr.toJS, axisIndex.toJS)
            as js.JSArray)
        .toDart;

    return FontAxisWasm(
        (array[0] as js.JSNumber).toDartInt,
        (array[1] as js.JSNumber).toDartDouble,
        (array[2] as js.JSNumber).toDartDouble,
        (array[3] as js.JSNumber).toDartDouble);
  }

  @override
  bool moveNext() => ++axisIndex < axisCount;
}

class _FontAxisList extends IterableMixin<FontAxis> {
  int fontPtr;
  _FontAxisList(this.fontPtr);

  @override
  Iterator<FontAxis> get iterator => FontAxisIterator(fontPtr);
}

/// A Font created and owned by Dart code. User is expected to call
/// dispose to release the font when they are done with it.
class StrongFontWasm extends FontWasm {
  StrongFontWasm(int fontPtr) : super(fontPtr);

  @override
  void dispose() => _deleteFont.callAsFunction(null, fontPtr.toJS);
}

Font? decodeFont(Uint8List bytes) {
  int ptr =
      (_makeFont.callAsFunction(null, bytes.toJS) as js.JSNumber).toDartInt;
  if (ptr == 0) {
    return null;
  }
  return StrongFontWasm(ptr);
}

Future<bool> initFont() async {
  // Temp fix for Flutter 3.10.0 issue - https://github.com/flutter/flutter/issues/126713
  if (js.globalContext['fixRequireJs'] != null) {
    js.globalContext.callMethod('fixRequireJs'.toJS);
  }

  void _linkWasmFunctions(js.JSObject module) {
    var init = module['init'] as js.JSFunction;
    init.callAsFunction();
    _makeFont = module['makeFont'] as js.JSFunction;
    _fontAxis = module['fontAxis'] as js.JSFunction;
    _fontAxisValue = module['fontAxisValue'] as js.JSFunction;
    _fontAxisCount = module['fontAxisCount'] as js.JSFunction;
    _makeFontWithOptions = module['makeFontWithOptions'] as js.JSFunction;
    _deleteFont = module['deleteFont'] as js.JSFunction;
    _makeGlyphPath = module['makeGlyphPath'] as js.JSFunction;
    _deleteGlyphPath = module['deleteGlyphPath'] as js.JSFunction;
    _shapeText = module['shapeText'] as js.JSFunction;
    _setFallbackFonts = module['setFallbackFonts'] as js.JSFunction;
    _deleteShapeResult = module['deleteShapeResult'] as js.JSFunction;
    _breakLines = module['breakLines'] as js.JSFunction;
    _deleteLines = module['deleteLines'] as js.JSFunction;
    _fontFeatures = module['fontFeatures'] as js.JSFunction;
    _fontAscent = module['fontAscent'] as js.JSFunction;
    _fontDescent = module['fontDescent'] as js.JSFunction;
    _disableFallbackFonts = module['disableFallbackFonts'] as js.JSFunction;
    _enableFallbackFonts = module['enableFallbackFonts'] as js.JSFunction;

    AudioEngineWasm.initWasmModule(module);
    LayoutEngineWasm.initWasmModule(module);
  }

  Future<bool> _loadWasm(
    String source,
    String name, {
    bool isRelative = false,
  }) async {
    var script = html.HTMLScriptElement()
      ..src = const bool.fromEnvironment(
        'LOCAL_RIVE_FLUTTER_WASM',
        defaultValue: false,
      )
          ? 'http://localhost:8282/release/$source'
          : isRelative
              ? source
              : 'assets/wasm/js/$source'
      ..type = 'application/javascript'
      ..defer = true;

    html.document.body!.append(script);
    await script.onLoad.first;

    var initWasm = js.globalContext[name] as js.JSFunction;
    var promise = initWasm.callAsFunction() as js.JSObject;
    var thenFunction = promise['then'] as js.JSFunction;

    var completer = Completer<bool>();
    thenFunction.callAsFunction(
      promise,
      (js.JSObject module) {
        _linkWasmFunctions(module);
        completer.complete(true);
      }.toJS,
      ((js.JSObject error) => completer.complete(false)).toJS,
    );
    return completer.future;
  }

  var env = const String.fromEnvironment(
    'RIVE_ENVIRONMENT',
    defaultValue: 'unknown',
  );

  if (env != 'unknown' &&
      defaultTargetPlatform != TargetPlatform.iOS &&
      defaultTargetPlatform != TargetPlatform.android) {
    // Try threaded version.
    if (await _loadWasm('rive_text.js?v=DEPLOYMENTVERSION', 'RiveText',
        isRelative: true)) {
      return true;
    }
  }

  // Try simd version.
  if (await _loadWasm('simd/rive_text.js', 'RiveText')) {
    return true;
  }
  // Try non-simd version.
  if (await _loadWasm('rive_text.js', 'RiveTextNoSimd')) {
    return true;
  }

  // Couldn't load a valid wasm module.
  return false;
}

void setFallbackFonts(List<Font> fonts) {
  _setFallbackFonts.callAsFunction(
    null,
    Uint32List.fromList(
      fonts
          .cast<FontWasm>()
          .map((font) => font.fontPtr)
          .toList(growable: false),
    ).toJS,
  );
}

void disableFallbackFonts() {
  _disableFallbackFonts.callAsFunction(
    null,
  );
}

void enableFallbackFonts() {
  _enableFallbackFonts.callAsFunction(
    null,
  );
}
