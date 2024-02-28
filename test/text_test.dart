import 'package:flutter_test/flutter_test.dart';
import 'package:rive_common/math.dart';
// ignore: implementation_imports
import 'package:rive_common/rive_text.dart';
import 'package:rive_common/src/utilities/list_equality.dart';
import 'src/utils.dart';

void main() {
  test('text shaping works', () async {
    await Font.initialize();
    final bytes = loadFile('assets/RobotoFlex.ttf');
    expect(bytes.lengthInBytes, 1654412);

    var roboto = Font.decode(bytes.buffer.asUint8List());
    expect(roboto, isNotNull);

    var text = 'ffi test';

    var runs = [
      TextRun(
        font: roboto!,
        fontSize: 32.0,
        unicharCount: text.length,
        styleId: 0,
      )
    ];

    var result = runs.first.font.shape(text, runs);
    expect(result.paragraphs.length, 1);
    expect(result.paragraphs.first.runs.length, 1);
    var glyphRun = result.paragraphs.first.runs.first;

    // ffi gets ligated as a single glyph
    expect(glyphRun.glyphCount, 6);
    expect(glyphRun.textIndexAt(0), 0); // ffi
    expect(glyphRun.textIndexAt(1), 3); // space after ffi

    var breakLinesResult = result.breakLines(60, TextAlign.left);
    expect(breakLinesResult.length, 1); // 1 paragraph
    expect(breakLinesResult.first.length, 2); // 2 lines in the paragraph
    // first line shows first glyph on the left
    expect(breakLinesResult.first.first.startIndex, 0);
    // second line shows third glyph on the left, which is the start of 'test'
    expect(breakLinesResult.first[1].startIndex, 2);
  });

  test('tag ids are as expected', () {
    expect(FontTag.tagToName(1869640570), 'opsz');
    expect(FontTag.tagToName(1196572996), 'GRAD');
    expect(FontTag.tagToName(1497454675), 'YAXS');
    expect(FontTag.tagToName(2003265652), 'wght');
  });

  test('variable axes load correctly', () async {
    await Font.initialize();
    final bytes = loadFile('assets/RobotoFlex.ttf');
    expect(bytes.lengthInBytes, 1654412);

    var roboto = Font.decode(bytes.buffer.asUint8List());
    expect(roboto, isNotNull);
    expect(roboto!.axes.length, 13);
    var axes = roboto.axes.toList(growable: false);
    expect(axes[0].tag, 2003265652);
    expect(axes[0].name, 'wght');
    expect(axes[0].min, 100);
    expect(axes[0].def, 400);
    expect(axes[0].max, 1000);

    expect(axes[1].tag, 2003072104);
    expect(axes[1].name, 'wdth');
    expect(axes[1].min, 25);
    expect(axes[1].def, 100);
    expect(axes[1].max, 151);

    expect(axes[2].tag, 1869640570);
    expect(axes[2].name, 'opsz');
    expect(axes[2].min, 8);
    expect(axes[2].def, 14);
    expect(axes[2].max, 144);

    expect(axes[3].tag, 1196572996);
    expect(axes[3].name, 'GRAD');
    expect(axes[3].min, -200);
    expect(axes[3].def, 0);
    expect(axes[3].max, 150);

    expect(axes[4].name, 'slnt');
    expect(axes[4].min, -10);
    expect(axes[4].def, 0);
    expect(axes[4].max, 0);

    expect(axes[5].name, 'XTRA');
    expect(axes[5].min, 323);
    expect(axes[5].def, 468);
    expect(axes[5].max, 603);

    expect(axes[6].name, 'XOPQ');
    expect(axes[6].min, 27);
    expect(axes[6].def, 96);
    expect(axes[6].max, 175);

    expect(axes[7].name, 'YOPQ');
    expect(axes[7].min, 25);
    expect(axes[7].def, 79);
    expect(axes[7].max, 135);

    expect(axes[8].name, 'YTLC');
    expect(axes[8].min, 416);
    expect(axes[8].def, 514);
    expect(axes[8].max, 570);

    expect(axes[9].name, 'YTUC');
    expect(axes[9].min, 528);
    expect(axes[9].def, 712);
    expect(axes[9].max, 760);

    expect(axes[10].name, 'YTAS');
    expect(axes[10].min, 649);
    expect(axes[10].def, 750);
    expect(axes[10].max, 854);

    expect(axes[11].name, 'YTDE');
    expect(axes[11].min, -305);
    expect(axes[11].def, -203);
    expect(axes[11].max, -98);

    expect(axes[12].name, 'YTFI');
    expect(axes[12].min, 560);
    expect(axes[12].def, 738);
    expect(axes[12].max, 788);
  });

  List<Vec2D> pointsFromGlyph(RawPath path) {
    List<Vec2D> points = [];
    for (final command in path) {
      switch (command.verb) {
        case RawPathVerb.move:
          points.add(command.point(0));
          break;
        case RawPathVerb.line:
          points.add(command.point(1));
          break;
        case RawPathVerb.quad:
          points.add(command.point(1));
          points.add(command.point(2));
          break;
        case RawPathVerb.cubic:
          points.add(command.point(1));
          points.add(command.point(2));
          points.add(command.point(3));
          break;
        case RawPathVerb.close:
          break;
      }
    }
    return points;
  }

  test('variable font provides different glyphs', () async {
    await Font.initialize();
    final bytes = loadFile('assets/RobotoFlex.ttf');
    expect(bytes.lengthInBytes, 1654412);

    var roboto = Font.decode(bytes.buffer.asUint8List());
    expect(roboto, isNotNull);
    expect(roboto!.axes.length, 13);
    var axes = roboto.axes.toList(growable: false);
    expect(axes[2].name, 'opsz');

    var robotoVaried = roboto.withOptions([axes[2].valueAt(122)], []);
    expect(robotoVaried, isNotNull);

    var aShape = roboto
        .shape('a', [TextRun(font: roboto, fontSize: 12, unicharCount: 1)]);

    // a should be glyph id 68
    expect(aShape.paragraphs.first.runs.first.glyphIdAt(0), 68);
    aShape.dispose();

    var aShapeVaried = robotoVaried!.shape(
        'a', [TextRun(font: robotoVaried, fontSize: 12, unicharCount: 1)]);
    expect(aShapeVaried.paragraphs.first.runs.first.glyphIdAt(0), 68);
    aShapeVaried.dispose();

    var aGlyph = roboto.getPath(68);
    expect(aGlyph.length, 38);
    var aGlyphVaried = robotoVaried.getPath(68);
    expect(aGlyphVaried.length, 38);

    var points = pointsFromGlyph(aGlyph);
    var pointsVaried = pointsFromGlyph(aGlyphVaried);
    expect(points.length, pointsVaried.length);

    expect(iterableEquals(points, pointsVaried), false);
  });
}
