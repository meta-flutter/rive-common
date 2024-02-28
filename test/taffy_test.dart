import 'dart:ui' as ui;
import 'package:flutter_test/flutter_test.dart';
import 'package:rive_common/rive_taffy.dart';

const epsilon = 1E-6;
void main() {
  test('taffy style defaults are as expected', () async {
    var taffy = Taffy.make();
    expect(taffy, isNotNull);

    var style = taffy.defaultStyle();
    expect(style.display, TaffyDisplay.flex);
    expect(style.position, TaffyPosition.relative);
    expect(style.overflow.x, TaffyOverflow.visible);
    expect(style.overflow.y, TaffyOverflow.visible);
    expect(style.position, TaffyPosition.relative);
    expect(style.inset.left.tag, TaffyDimensionTag.auto);
    expect(style.inset.left.value, closeTo(0, epsilon));
    expect(style.inset.right.tag, TaffyDimensionTag.auto);
    expect(style.flexGrow, 0);
    expect(style.flexShrink, 1);
  });

  test('can instance taffy', () async {
    var taffy = Taffy.make();
    expect(taffy, isNotNull);

    var result = taffy.node();
    expect(result.tag, TaffyResultTag.ok);
    expect(result.node, isNotNull);
    expect(result.error, isNull);

    var style = taffy.defaultStyle();
    style.size.width.tag = TaffyDimensionTag.points;
    style.size.width.value = 100;
    style.size.height.tag = TaffyDimensionTag.points;
    style.size.height.value = 100;
    expect(style.display, TaffyDisplay.flex);
    expect(style.position, TaffyPosition.relative);
    expect(style.flexGrow, 0);
    expect(style.flexShrink, 1);

    var setStyleResult = taffy.setStyle(node: result.node!, style: style);
    expect(setStyleResult.tag, TaffyResultTag.ok);

    var layoutResult = taffy.computeLayout(node: result.node!);
    expect(layoutResult.tag, TaffyResultTag.ok);

    var layoutValueResult = taffy.layout(node: result.node!);
    expect(layoutValueResult.tag, TaffyResultTag.ok);
    expect(layoutValueResult.layout, isNotNull);
    expect(layoutValueResult.layout!.location, Offset.zero);
    expect(layoutValueResult.layout!.size, const ui.Size(100, 100));
  });

  test('can set children with taffy', () async {
    var taffy = Taffy.make();
    expect(taffy, isNotNull);

    var root = taffy.node().node!;

    var childA = taffy.node().node!;
    {
      var style = taffy.defaultStyle();
      style.size.width.tag = TaffyDimensionTag.points;
      style.size.width.value = 100;
      style.size.height.tag = TaffyDimensionTag.points;
      style.size.height.value = 100;
      taffy.setStyle(node: childA, style: style);
    }
    var childB = taffy.node().node!;
    {
      var style = taffy.defaultStyle();

      style.margin.left.tag = TaffyDimensionTag.points;
      style.margin.left.value = 10;

      style.size.width.tag = TaffyDimensionTag.points;
      style.size.width.value = 200;

      style.size.height.tag = TaffyDimensionTag.points;
      style.size.height.value = 50;
      taffy.setStyle(node: childB, style: style);
    }

    var result = taffy.setChildren(parent: root, children: [childA, childB]);
    expect(result.tag, TaffyResultTag.ok);

    var layoutResult = taffy.computeLayout(node: root);
    expect(layoutResult.tag, TaffyResultTag.ok);

    var layoutValueResult = taffy.layout(node: root);
    expect(layoutValueResult.tag, TaffyResultTag.ok);

    var location = layoutValueResult.layout!.location;
    var size = layoutValueResult.layout!.size;
    print('Layout!! $location $size');

    expect(taffy.remove(node: childA).tag, TaffyResultTag.ok);
    {
      taffy.markDirty(node: root);
      var layoutResult = taffy.computeLayout(node: root);
      expect(layoutResult.tag, TaffyResultTag.ok);

      var layoutValueResult = taffy.layout(node: root);
      expect(layoutValueResult.tag, TaffyResultTag.ok);

      print('Layout After Removal!! $location $size');
    }
  });
}
