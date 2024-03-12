import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:rive_common/layout_engine.dart';

const epsilon = 1E-6;

void main() {
  test('layout style tests', () async {
    var style = LayoutStyle.make();
    expect(style.alignContent, LayoutAlign.flexStart);

    style.alignContent = LayoutAlign.auto;
    expect(style.alignContent, LayoutAlign.auto);

    style.alignContent = LayoutAlign.center;
    expect(style.alignContent, LayoutAlign.center);

    expect(style.direction, LayoutDirection.inherit);

    style.direction = LayoutDirection.ltr;
    expect(style.direction, LayoutDirection.ltr);

    style.direction = LayoutDirection.rtl;
    expect(style.direction, LayoutDirection.rtl);

    expect(style.flexDirection, LayoutFlexDirection.column);

    style.flexDirection = LayoutFlexDirection.columnReverse;
    expect(style.flexDirection, LayoutFlexDirection.columnReverse);

    style.flexDirection = LayoutFlexDirection.row;
    expect(style.flexDirection, LayoutFlexDirection.row);

    style.flexDirection = LayoutFlexDirection.rowReverse;
    expect(style.flexDirection, LayoutFlexDirection.rowReverse);

    expect(style.justifyContent, LayoutJustify.flexStart);

    style.justifyContent = LayoutJustify.flexEnd;
    expect(style.justifyContent, LayoutJustify.flexEnd);

    style.justifyContent = LayoutJustify.center;
    expect(style.justifyContent, LayoutJustify.center);

    expect(style.alignItems, LayoutAlign.stretch);

    style.alignItems = LayoutAlign.auto;
    expect(style.alignItems, LayoutAlign.auto);

    expect(style.alignSelf, LayoutAlign.auto);

    style.alignSelf = LayoutAlign.stretch;
    expect(style.alignSelf, LayoutAlign.stretch);

    expect(style.positionType, LayoutPosition.static);

    style.positionType = LayoutPosition.absolute;
    expect(style.positionType, LayoutPosition.absolute);

    expect(style.flexWrap, LayoutWrap.noWrap);

    style.flexWrap = LayoutWrap.wrap;
    expect(style.flexWrap, LayoutWrap.wrap);

    style.flexWrap = LayoutWrap.wrapReverse;
    expect(style.flexWrap, LayoutWrap.wrapReverse);

    expect(style.overflow, LayoutOverflow.visible);

    style.overflow = LayoutOverflow.hidden;
    expect(style.overflow, LayoutOverflow.hidden);

    expect(style.display, LayoutDisplay.flex);

    style.display = LayoutDisplay.none;
    expect(style.display, LayoutDisplay.none);

    expect(style.flex, null);

    style.flex = 0.5;
    expect(style.flex, 0.5);

    style.flex = null;
    expect(style.flex, null);

    expect(style.flexGrow, null);

    style.flexGrow = 0.5;
    expect(style.flexGrow, 0.5);

    style.flexGrow = null;
    expect(style.flexGrow, null);

    expect(style.flexShrink, null);

    style.flexShrink = 0.5;
    expect(style.flexShrink, 0.5);

    style.flexShrink = null;
    expect(style.flexShrink, null);

    expect(style.flexBasis.value.isNaN, true);
    expect(style.flexBasis.unit, LayoutUnit.auto);

    style.flexBasis = LayoutValue(value: 34.7, unit: LayoutUnit.percent);
    expect(style.flexBasis.unit, LayoutUnit.percent);
    expect(style.flexBasis.value, closeTo(34.7, epsilon));

    style.flexBasis = LayoutValue(value: 22.2, unit: LayoutUnit.point);
    expect(style.flexBasis.unit, LayoutUnit.point);
    expect(style.flexBasis.value, closeTo(22.2, epsilon));

    var leftMargin = style.getMargin(LayoutEdge.left);
    expect(leftMargin.unit, LayoutUnit.undefined);
    expect(leftMargin.value.isNaN, true);

    style.setMargin(
      LayoutEdge.left,
      LayoutValue(
        unit: LayoutUnit.point,
        value: 22.0,
      ),
    );
    leftMargin = style.getMargin(LayoutEdge.left);
    expect(leftMargin.unit, LayoutUnit.point);
    expect(leftMargin.value, 22.0);

    var leftPosition = style.getPosition(LayoutEdge.left);
    expect(leftPosition.unit, LayoutUnit.undefined);
    expect(leftPosition.value.isNaN, true);

    style.setPosition(
      LayoutEdge.left,
      LayoutValue(
        unit: LayoutUnit.point,
        value: 22.0,
      ),
    );
    leftPosition = style.getPosition(LayoutEdge.left);
    expect(leftPosition.unit, LayoutUnit.point);
    expect(leftPosition.value, 22.0);

    var leftPadding = style.getPadding(LayoutEdge.left);
    expect(leftPadding.unit, LayoutUnit.undefined);
    expect(leftPadding.value.isNaN, true);

    style.setPadding(
      LayoutEdge.left,
      LayoutValue(
        unit: LayoutUnit.point,
        value: 22.0,
      ),
    );
    leftPadding = style.getPadding(LayoutEdge.left);
    expect(leftPadding.unit, LayoutUnit.point);
    expect(leftPadding.value, 22.0);

    var leftBorder = style.getBorder(LayoutEdge.left);
    expect(leftBorder.unit, LayoutUnit.undefined);
    expect(leftBorder.value.isNaN, true);

    style.setBorder(
      LayoutEdge.left,
      LayoutValue(
        unit: LayoutUnit.point,
        value: 22.0,
      ),
    );
    leftBorder = style.getBorder(LayoutEdge.left);
    expect(leftBorder.unit, LayoutUnit.point);
    expect(leftBorder.value, 22.0);

    var columnGutter = style.getGap(LayoutGutter.column);
    expect(columnGutter.unit, LayoutUnit.undefined);
    expect(columnGutter.value.isNaN, true);

    style.setGap(
      LayoutGutter.column,
      const LayoutValue.percent(0.22),
    );

    columnGutter = style.getGap(LayoutGutter.column);
    expect(columnGutter.unit, LayoutUnit.percent);
    expect(columnGutter.value, closeTo(0.22, epsilon));

    var node = LayoutNode.make();
    expect(node.nodeType, LayoutNodeType.normal);

    node.nodeType = LayoutNodeType.text;
    expect(node.nodeType, LayoutNodeType.text);
  });

  test('computed layout tests', () async {
    var style = LayoutStyle.make();
    style.setDimension(LayoutDimension.width, const LayoutValue.points(100));
    style.setDimension(LayoutDimension.height, const LayoutValue.points(100));
    style.setPadding(LayoutEdge.all, const LayoutValue.points(20));
    style.positionType = LayoutPosition.relative;

    var nodeA = LayoutNode.make()..setStyle(style);
    var nodeB = LayoutNode.make()..setStyle(style);
    var nodeC = LayoutNode.make()..setStyle(style);

    var root = LayoutNode.make()
      ..setStyle(
        LayoutStyle.make()
          ..flexDirection = LayoutFlexDirection.row
          ..setPadding(
            LayoutEdge.all,
            const LayoutValue.points(20),
          ),
      );
    root.insertChild(nodeA, 0);
    root.insertChild(nodeB, 1);
    root.insertChild(nodeC, 2);
    root.calculateLayout(1024, 768, LayoutDirection.ltr);

    expect(root.layout.width, 1024);
    expect(root.layout.height, 768);

    expect(nodeA.layout.left, 20);
    expect(nodeA.layout.top, 20);
    expect(nodeA.layout.width, 100);
    expect(nodeA.layout.height, 100);

    expect(nodeB.layout.left, 120);
    expect(nodeB.layout.top, 20);
    expect(nodeB.layout.width, 100);
    expect(nodeB.layout.height, 100);

    expect(nodeC.layout.left, 220);
    expect(nodeC.layout.top, 20);
    expect(nodeC.layout.width, 100);
    expect(nodeC.layout.height, 100);
  });

  test('computed layout with measure tests', () async {
    var style = LayoutStyle.make();
    style.setDimension(LayoutDimension.width, const LayoutValue.points(100));
    style.setDimension(LayoutDimension.height, const LayoutValue.points(100));
    style.setPadding(LayoutEdge.all, const LayoutValue.points(20));
    style.positionType = LayoutPosition.relative;

    var nodeA = LayoutNode.make()..setStyle(style);
    var nodeB = LayoutNode.make()
      ..setStyle(
        LayoutStyle.make()
          ..positionType = LayoutPosition.relative
          ..setPadding(
            LayoutEdge.all,
            const LayoutValue.points(20),
          ),
      )
      ..measureFunction =
          (node, width, widthMode, height, heightMode) => const ui.Size(60, 60);

    var nodeC = LayoutNode.make()..setStyle(style);

    var root = LayoutNode.make()
      ..setStyle(
        LayoutStyle.make()
          ..alignItems = LayoutAlign.flexStart
          ..flexDirection = LayoutFlexDirection.row
          ..setPadding(
            LayoutEdge.all,
            const LayoutValue.points(20),
          ),
      );
    root.insertChild(nodeA, 0);
    root.insertChild(nodeB, 1);
    root.insertChild(nodeC, 2);

    root.calculateLayout(1024, 768, LayoutDirection.ltr);

    expect(root.layout.width, 1024);
    expect(root.layout.height, 768);

    expect(nodeA.layout.left, 20);
    expect(nodeA.layout.top, 20);
    expect(nodeA.layout.width, 100);
    expect(nodeA.layout.height, 100);

    expect(nodeB.layout.left, 120);
    expect(nodeB.layout.top, 20);
    expect(nodeB.layout.width, 100);
    expect(nodeB.layout.height, 100);

    expect(nodeC.layout.left, 220);
    expect(nodeC.layout.top, 20);
    expect(nodeC.layout.width, 100);
    expect(nodeC.layout.height, 100);

    // Clear the measure function and compute again.
    nodeB.measureFunction = null;
    nodeB.markDirty();
    root.calculateLayout(1024, 768, LayoutDirection.ltr);

    expect(root.layout.width, 1024);
    expect(root.layout.height, 768);

    expect(nodeA.layout.left, 20);
    expect(nodeA.layout.top, 20);
    expect(nodeA.layout.width, 100);
    expect(nodeA.layout.height, 100);

    expect(nodeB.layout.left, 120);
    expect(nodeB.layout.top, 20);
    expect(nodeB.layout.width, 40);
    expect(nodeB.layout.height, 40);

    expect(nodeC.layout.left, 160);
    expect(nodeC.layout.top, 20);
    expect(nodeC.layout.width, 100);
    expect(nodeC.layout.height, 100);
  });
}
