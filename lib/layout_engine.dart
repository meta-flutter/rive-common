import 'dart:ui';

import 'src/layout_engine_ffi.dart'
    if (dart.library.js_interop) 'src/layout_engine_wasm.dart';

enum LayoutOverflow { visible, hidden, scroll }

enum LayoutAlign {
  auto,
  flexStart,
  center,
  flexEnd,
  stretch,
  baseline,
  spaceBetween,
  spaceAround,
}

enum LayoutDirection {
  inherit,
  ltr,
  rtl,
}

enum LayoutFlexDirection {
  column,
  columnReverse,
  row,
  rowReverse,
}

enum LayoutGutter {
  column,
  row,
  all,
}

enum LayoutDisplay {
  flex,
  none,
}

enum LayoutJustify {
  flexStart,
  center,
  flexEnd,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}

enum LayoutMeasureMode {
  undefined,
  exactly,
  atMost,
}

enum LayoutNodeType {
  normal,
  text,
}

enum LayoutWrap {
  noWrap,
  wrap,
  wrapReverse,
}

enum LayoutPosition {
  static,
  relative,
  absolute,
}

enum LayoutDimension {
  width,
  height,
}

enum LayoutUnit {
  undefined,
  point,
  percent,
  auto;

  bool get isPercent => this == LayoutUnit.percent;

  bool get isInteractable =>
      [LayoutUnit.point, LayoutUnit.percent].contains(this);

  bool get isNotInteractable =>
      [LayoutUnit.auto, LayoutUnit.undefined].contains(this);
}

enum LayoutEdge {
  left,
  top,
  right,
  bottom,
  start,
  end,
  horizontal,
  vertical,
  all,
}

enum LayoutError {
  none,
  stretchFlexBasis, // 1
  all, // 2147483647
  classic, // 2147483646
}

class LayoutValue {
  final double value;
  final LayoutUnit unit;

  const LayoutValue({
    required this.value,
    required this.unit,
  });

  const LayoutValue.points(this.value) : unit = LayoutUnit.point;
  const LayoutValue.undefined()
      : unit = LayoutUnit.undefined,
        value = double.nan;

  const LayoutValue.auto()
      : unit = LayoutUnit.auto,
        value = double.nan;

  const LayoutValue.percent(this.value) : unit = LayoutUnit.percent;
}

abstract class LayoutStyle {
  static LayoutStyle make() {
    return makeLayoutStyle();
  }

  void dispose();

  LayoutAlign get alignContent;
  set alignContent(LayoutAlign value);

  LayoutDirection get direction;
  set direction(LayoutDirection value);

  LayoutFlexDirection get flexDirection;
  set flexDirection(LayoutFlexDirection value);

  LayoutJustify get justifyContent;
  set justifyContent(LayoutJustify value);

  LayoutAlign get alignItems;
  set alignItems(LayoutAlign value);

  LayoutAlign get alignSelf;
  set alignSelf(LayoutAlign value);

  LayoutPosition get positionType;
  set positionType(LayoutPosition value);

  LayoutWrap get flexWrap;
  set flexWrap(LayoutWrap value);

  LayoutOverflow get overflow;
  set overflow(LayoutOverflow value);

  LayoutDisplay get display;
  set display(LayoutDisplay value);

  double? get flex;
  set flex(double? value);

  double? get flexGrow;
  set flexGrow(double? value);

  double? get flexShrink;
  set flexShrink(double? value);

  LayoutValue get flexBasis;
  set flexBasis(LayoutValue value);

  LayoutValue getMargin(LayoutEdge edge);
  void setMargin(LayoutEdge edge, LayoutValue value);

  LayoutValue getPosition(LayoutEdge edge);
  void setPosition(LayoutEdge edge, LayoutValue value);

  LayoutValue getPadding(LayoutEdge edge);
  void setPadding(LayoutEdge edge, LayoutValue value);

  LayoutValue getBorder(LayoutEdge edge);
  void setBorder(LayoutEdge edge, LayoutValue value);

  LayoutValue getGap(LayoutGutter gutter);
  void setGap(LayoutGutter gutter, LayoutValue value);

  LayoutValue getDimension(LayoutDimension dimension);
  void setDimension(LayoutDimension dimension, LayoutValue value);

  LayoutValue getMinDimension(LayoutDimension dimension);
  void setMinDimension(LayoutDimension dimension, LayoutValue value);

  LayoutValue getMaxDimension(LayoutDimension dimension);
  void setMaxDimension(LayoutDimension dimension, LayoutValue value);
}

abstract class Layout {
  double get left;
  double get top;
  double get width;
  double get height;
}

typedef MeasureFunction = Size Function(
  LayoutNode node,
  double width,
  LayoutMeasureMode widthMode,
  double height,
  LayoutMeasureMode heightMode,
);

typedef BaselineFunction = double Function(
  LayoutNode node,
  double width,
  double height,
);

abstract class LayoutNode {
  static LayoutNode make() {
    return makeLayoutNode();
  }

  void dispose();

  static LayoutNode fromExternal(dynamic ref) {
    return makeLayoutNodeExternal(ref);
  }

  void setStyle(LayoutStyle style);

  LayoutNodeType get nodeType;
  set nodeType(LayoutNodeType value);

  void clearChildren();
  void insertChild(LayoutNode node, int index);
  void removeChild(LayoutNode node);

  void calculateLayout(
      double availableWidth, double availableHeight, LayoutDirection direction);

  /// Provide a function for measuring the desired dimensions of the LayoutNode.
  /// This lets the layout engine know the intrinsic size of the contents. This
  /// doesn't guarantee the final size of the node will match but lets the
  /// layout attempt to provide the desired size when possible. Only works on
  /// leaf nodes (nodes with no further child layout nodes).
  MeasureFunction? get measureFunction;
  set measureFunction(MeasureFunction? value);

  /// Provide a function for measuring the baseline (in Y) of the contents of
  /// the node. The layout engine uses this when the alignment is set to
  /// baseline. Only works on leaf nodes (nodes with no further child layout
  /// nodes).
  BaselineFunction? get baselineFunction;
  set baselineFunction(BaselineFunction? value);

  void markDirty();

  Layout get layout;
}
