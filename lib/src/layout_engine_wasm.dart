import 'dart:collection';
import 'dart:js' as js;
import 'dart:typed_data';

import 'package:rive_common/layout_engine.dart';

late js.JsFunction _makeYogaStyle;
late js.JsFunction _disposeYogaStyle;
late js.JsFunction _yogaStyleGetAlignContent;
late js.JsFunction _yogaStyleSetAlignContent;
late js.JsFunction _yogaStyleGetDirection;
late js.JsFunction _yogaStyleSetDirection;
late js.JsFunction _yogaStyleGetFlexDirection;
late js.JsFunction _yogaStyleSetFlexDirection;
late js.JsFunction _yogaStyleGetJustifyContent;
late js.JsFunction _yogaStyleSetJustifyContent;
late js.JsFunction _yogaStyleGetAlignItems;
late js.JsFunction _yogaStyleSetAlignItems;
late js.JsFunction _yogaStyleGetAlignSelf;
late js.JsFunction _yogaStyleSetAlignSelf;
late js.JsFunction _yogaStyleGetPositionType;
late js.JsFunction _yogaStyleSetPositionType;
late js.JsFunction _yogaStyleGetFlexWrap;
late js.JsFunction _yogaStyleSetFlexWrap;
late js.JsFunction _yogaStyleGetOverflow;
late js.JsFunction _yogaStyleSetOverflow;
late js.JsFunction _yogaStyleGetDisplay;
late js.JsFunction _yogaStyleSetDisplay;
late js.JsFunction _yogaStyleGetFlex;
late js.JsFunction _yogaStyleSetFlex;
late js.JsFunction _yogaStyleGetFlexGrow;
late js.JsFunction _yogaStyleSetFlexGrow;
late js.JsFunction _yogaStyleGetFlexShrink;
late js.JsFunction _yogaStyleSetFlexShrink;
late js.JsFunction _yogaStyleGetFlexBasis;
late js.JsFunction _yogaStyleSetFlexBasis;
late js.JsFunction _yogaStyleGetMargin;
late js.JsFunction _yogaStyleSetMargin;
late js.JsFunction _yogaStyleGetPosition;
late js.JsFunction _yogaStyleSetPosition;
late js.JsFunction _yogaStyleGetPadding;
late js.JsFunction _yogaStyleSetPadding;
late js.JsFunction _yogaStyleGetBorder;
late js.JsFunction _yogaStyleSetBorder;
late js.JsFunction _yogaStyleGetGap;
late js.JsFunction _yogaStyleSetGap;
late js.JsFunction _yogaStyleGetDimension;
late js.JsFunction _yogaStyleSetDimension;
late js.JsFunction _yogaStyleGetMinDimension;
late js.JsFunction _yogaStyleSetMinDimension;
late js.JsFunction _yogaStyleGetMaxDimension;
late js.JsFunction _yogaStyleSetMaxDimension;
late js.JsFunction _makeYogaNode;
late js.JsFunction _disposeYogaNode;
late js.JsFunction _yogaNodeCalculateLayout;
late js.JsFunction _yogaNodeGetLayout;
late js.JsFunction _yogaNodeSetMeasureFunc;
late js.JsFunction _yogaNodeClearMeasureFunc;
late js.JsFunction _yogaNodeSetBaselineFunc;
late js.JsFunction _yogaNodeClearBaselineFunc;
late js.JsFunction _yogaNodeMarkDirty;
late js.JsFunction _yogaNodeInsertChild;
late js.JsFunction _yogaNodeClearChildren;
late js.JsFunction _yogaNodeSetStyle;
late js.JsFunction _yogaNodeGetType;
late js.JsFunction _yogaNodeSetType;

// ignore: avoid_classes_with_only_static_members
class LayoutEngineWasm {
  static void initWasmModule(js.JsObject module) {
    _makeYogaStyle = module['makeYogaStyle'] as js.JsFunction;
    _disposeYogaStyle = module['disposeYogaStyle'] as js.JsFunction;
    _yogaStyleGetAlignContent =
        module['yogaStyleGetAlignContent'] as js.JsFunction;
    _yogaStyleSetAlignContent =
        module['yogaStyleSetAlignContent'] as js.JsFunction;
    _yogaStyleGetDirection = module['yogaStyleGetDirection'] as js.JsFunction;
    _yogaStyleSetDirection = module['yogaStyleSetDirection'] as js.JsFunction;
    _yogaStyleGetFlexDirection =
        module['yogaStyleGetFlexDirection'] as js.JsFunction;
    _yogaStyleSetFlexDirection =
        module['yogaStyleSetFlexDirection'] as js.JsFunction;
    _yogaStyleGetJustifyContent =
        module['yogaStyleGetJustifyContent'] as js.JsFunction;
    _yogaStyleSetJustifyContent =
        module['yogaStyleSetJustifyContent'] as js.JsFunction;
    _yogaStyleGetAlignItems = module['yogaStyleGetAlignItems'] as js.JsFunction;
    _yogaStyleSetAlignItems = module['yogaStyleSetAlignItems'] as js.JsFunction;
    _yogaStyleGetAlignSelf = module['yogaStyleGetAlignSelf'] as js.JsFunction;
    _yogaStyleSetAlignSelf = module['yogaStyleSetAlignSelf'] as js.JsFunction;
    _yogaStyleGetPositionType =
        module['yogaStyleGetPositionType'] as js.JsFunction;
    _yogaStyleSetPositionType =
        module['yogaStyleSetPositionType'] as js.JsFunction;
    _yogaStyleGetFlexWrap = module['yogaStyleGetFlexWrap'] as js.JsFunction;
    _yogaStyleSetFlexWrap = module['yogaStyleSetFlexWrap'] as js.JsFunction;
    _yogaStyleGetOverflow = module['yogaStyleGetOverflow'] as js.JsFunction;
    _yogaStyleSetOverflow = module['yogaStyleSetOverflow'] as js.JsFunction;
    _yogaStyleGetDisplay = module['yogaStyleGetDisplay'] as js.JsFunction;
    _yogaStyleSetDisplay = module['yogaStyleSetDisplay'] as js.JsFunction;
    _yogaStyleGetFlex = module['yogaStyleGetFlex'] as js.JsFunction;
    _yogaStyleSetFlex = module['yogaStyleSetFlex'] as js.JsFunction;
    _yogaStyleGetFlexGrow = module['yogaStyleGetFlexGrow'] as js.JsFunction;
    _yogaStyleSetFlexGrow = module['yogaStyleSetFlexGrow'] as js.JsFunction;
    _yogaStyleGetFlexShrink = module['yogaStyleGetFlexShrink'] as js.JsFunction;
    _yogaStyleSetFlexShrink = module['yogaStyleSetFlexShrink'] as js.JsFunction;
    _yogaStyleGetFlexBasis = module['yogaStyleGetFlexBasis'] as js.JsFunction;
    _yogaStyleSetFlexBasis = module['yogaStyleSetFlexBasis'] as js.JsFunction;
    _yogaStyleGetMargin = module['yogaStyleGetMargin'] as js.JsFunction;
    _yogaStyleSetMargin = module['yogaStyleSetMargin'] as js.JsFunction;
    _yogaStyleGetPosition = module['yogaStyleGetPosition'] as js.JsFunction;
    _yogaStyleSetPosition = module['yogaStyleSetPosition'] as js.JsFunction;
    _yogaStyleGetPadding = module['yogaStyleGetPadding'] as js.JsFunction;
    _yogaStyleSetPadding = module['yogaStyleSetPadding'] as js.JsFunction;
    _yogaStyleGetBorder = module['yogaStyleGetBorder'] as js.JsFunction;
    _yogaStyleSetBorder = module['yogaStyleSetBorder'] as js.JsFunction;
    _yogaStyleGetGap = module['yogaStyleGetGap'] as js.JsFunction;
    _yogaStyleSetGap = module['yogaStyleSetGap'] as js.JsFunction;
    _yogaStyleGetDimension = module['yogaStyleGetDimension'] as js.JsFunction;
    _yogaStyleSetDimension = module['yogaStyleSetDimension'] as js.JsFunction;
    _yogaStyleGetMinDimension =
        module['yogaStyleGetMinDimension'] as js.JsFunction;
    _yogaStyleSetMinDimension =
        module['yogaStyleSetMinDimension'] as js.JsFunction;
    _yogaStyleGetMaxDimension =
        module['yogaStyleGetMaxDimension'] as js.JsFunction;
    _yogaStyleSetMaxDimension =
        module['yogaStyleSetMaxDimension'] as js.JsFunction;
    _makeYogaNode = module['makeYogaNode'] as js.JsFunction;
    _disposeYogaNode = module['disposeYogaNode'] as js.JsFunction;
    _yogaNodeCalculateLayout =
        module['yogaNodeCalculateLayout'] as js.JsFunction;
    _yogaNodeGetLayout = module['yogaNodeGetLayout'] as js.JsFunction;
    _yogaNodeSetMeasureFunc = module['yogaNodeSetMeasureFunc'] as js.JsFunction;
    _yogaNodeClearMeasureFunc =
        module['yogaNodeClearMeasureFunc'] as js.JsFunction;
    _yogaNodeSetBaselineFunc =
        module['yogaNodeSetBaselineFunc'] as js.JsFunction;
    _yogaNodeClearBaselineFunc =
        module['yogaNodeClearBaselineFunc'] as js.JsFunction;
    _yogaNodeMarkDirty = module['yogaNodeMarkDirty'] as js.JsFunction;
    _yogaNodeInsertChild = module['yogaNodeInsertChild'] as js.JsFunction;
    _yogaNodeClearChildren = module['yogaNodeClearChildren'] as js.JsFunction;
    _yogaNodeSetStyle = module['yogaNodeSetStyle'] as js.JsFunction;
    _yogaNodeGetType = module['yogaNodeGetType'] as js.JsFunction;
    _yogaNodeSetType = module['yogaNodeSetType'] as js.JsFunction;
  }
}

LayoutValue _layoutValueFromJs(dynamic data) {
  if (data is js.JsObject) {
    return LayoutValue(
      value: data['value'] as double,
      unit: LayoutUnit.values[data['unit'] as int],
    );
  }
  return const LayoutValue.undefined();
}

class _LayoutWasm extends Layout {
  @override
  final double left;
  @override
  final double top;
  @override
  final double width;
  @override
  final double height;

  _LayoutWasm(this.left, this.top, this.width, this.height);
}

class LayoutStyleWasm extends LayoutStyle {
  int _nativePtr;

  LayoutStyleWasm(this._nativePtr);

  @override
  void dispose() {
    _disposeYogaStyle.apply(<dynamic>[_nativePtr]);
    _nativePtr = 0;
  }

  @override
  LayoutAlign get alignContent => LayoutAlign
      .values[_yogaStyleGetAlignContent.apply(<dynamic>[_nativePtr]) as int];

  @override
  set alignContent(LayoutAlign value) =>
      _yogaStyleSetAlignContent.apply(<dynamic>[_nativePtr, value.index]);

  @override
  LayoutDirection get direction => LayoutDirection
      .values[_yogaStyleGetDirection.apply(<dynamic>[_nativePtr]) as int];

  @override
  set direction(LayoutDirection value) =>
      _yogaStyleSetDirection.apply(<dynamic>[_nativePtr, value.index]);

  @override
  LayoutFlexDirection get flexDirection => LayoutFlexDirection
      .values[_yogaStyleGetFlexDirection.apply(<dynamic>[_nativePtr]) as int];

  @override
  set flexDirection(LayoutFlexDirection value) =>
      _yogaStyleSetFlexDirection.apply(<dynamic>[_nativePtr, value.index]);

  @override
  LayoutJustify get justifyContent => LayoutJustify
      .values[_yogaStyleGetJustifyContent.apply(<dynamic>[_nativePtr]) as int];

  @override
  set justifyContent(LayoutJustify value) =>
      _yogaStyleSetJustifyContent.apply(<dynamic>[_nativePtr, value.index]);

  @override
  LayoutAlign get alignItems => LayoutAlign
      .values[_yogaStyleGetAlignItems.apply(<dynamic>[_nativePtr]) as int];

  @override
  set alignItems(LayoutAlign value) =>
      _yogaStyleSetAlignItems.apply(<dynamic>[_nativePtr, value.index]);

  @override
  LayoutAlign get alignSelf => LayoutAlign
      .values[_yogaStyleGetAlignSelf.apply(<dynamic>[_nativePtr]) as int];

  @override
  set alignSelf(LayoutAlign value) =>
      _yogaStyleSetAlignSelf.apply(<dynamic>[_nativePtr, value.index]);

  @override
  LayoutPosition get positionType => LayoutPosition
      .values[_yogaStyleGetPositionType.apply(<dynamic>[_nativePtr]) as int];

  @override
  set positionType(LayoutPosition value) =>
      _yogaStyleSetPositionType.apply(<dynamic>[_nativePtr, value.index]);

  @override
  LayoutWrap get flexWrap => LayoutWrap
      .values[_yogaStyleGetFlexWrap.apply(<dynamic>[_nativePtr]) as int];

  @override
  set flexWrap(LayoutWrap value) =>
      _yogaStyleSetFlexWrap.apply(<dynamic>[_nativePtr, value.index]);

  @override
  LayoutOverflow get overflow => LayoutOverflow
      .values[_yogaStyleGetOverflow.apply(<dynamic>[_nativePtr]) as int];

  @override
  set overflow(LayoutOverflow value) =>
      _yogaStyleSetOverflow.apply(<dynamic>[_nativePtr, value.index]);

  @override
  LayoutDisplay get display => LayoutDisplay
      .values[_yogaStyleGetDisplay.apply(<dynamic>[_nativePtr]) as int];

  @override
  set display(LayoutDisplay value) =>
      _yogaStyleSetDisplay.apply(<dynamic>[_nativePtr, value.index]);

  @override
  double? get flex {
    double value = _yogaStyleGetFlex.apply(<dynamic>[_nativePtr]) as double;
    if (value.isNaN) {
      return null;
    }
    return value;
  }

  @override
  set flex(double? value) => _yogaStyleSetFlex
      .apply(<dynamic>[_nativePtr, value == null ? double.nan : value]);

  @override
  double? get flexGrow {
    double value = _yogaStyleGetFlexGrow.apply(<dynamic>[_nativePtr]) as double;
    if (value.isNaN) {
      return null;
    }
    return value;
  }

  @override
  set flexGrow(double? value) => _yogaStyleSetFlexGrow
      .apply(<dynamic>[_nativePtr, value == null ? double.nan : value]);

  @override
  double? get flexShrink {
    double value =
        _yogaStyleGetFlexShrink.apply(<dynamic>[_nativePtr]) as double;
    if (value.isNaN) {
      return null;
    }
    return value;
  }

  @override
  set flexShrink(double? value) => _yogaStyleSetFlexShrink
      .apply(<dynamic>[_nativePtr, value == null ? double.nan : value]);

  @override
  LayoutValue get flexBasis =>
      _layoutValueFromJs(_yogaStyleGetFlexBasis.apply(<dynamic>[_nativePtr]));

  @override
  set flexBasis(LayoutValue value) => _yogaStyleSetFlexBasis
      .apply(<dynamic>[_nativePtr, value.value, value.unit.index]);

  @override
  LayoutValue getMargin(LayoutEdge edge) => _layoutValueFromJs(
      _yogaStyleGetMargin.apply(<dynamic>[_nativePtr, edge.index]));

  @override
  void setMargin(LayoutEdge edge, LayoutValue value) => _yogaStyleSetMargin
      .apply(<dynamic>[_nativePtr, edge.index, value.value, value.unit.index]);

  @override
  LayoutValue getPosition(LayoutEdge edge) => _layoutValueFromJs(
      _yogaStyleGetPosition.apply(<dynamic>[_nativePtr, edge.index]));

  @override
  void setPosition(LayoutEdge edge, LayoutValue value) => _yogaStyleSetPosition
      .apply(<dynamic>[_nativePtr, edge.index, value.value, value.unit.index]);

  @override
  LayoutValue getPadding(LayoutEdge edge) => _layoutValueFromJs(
      _yogaStyleGetPadding.apply(<dynamic>[_nativePtr, edge.index]));

  @override
  void setPadding(LayoutEdge edge, LayoutValue value) => _yogaStyleSetPadding
      .apply(<dynamic>[_nativePtr, edge.index, value.value, value.unit.index]);

  @override
  LayoutValue getBorder(LayoutEdge edge) => _layoutValueFromJs(
      _yogaStyleGetBorder.apply(<dynamic>[_nativePtr, edge.index]));

  @override
  void setBorder(LayoutEdge edge, LayoutValue value) => _yogaStyleSetBorder
      .apply(<dynamic>[_nativePtr, edge.index, value.value, value.unit.index]);

  @override
  LayoutValue getGap(LayoutGutter gutter) => _layoutValueFromJs(
      _yogaStyleGetGap.apply(<dynamic>[_nativePtr, gutter.index]));

  @override
  void setGap(LayoutGutter gutter, LayoutValue value) => _yogaStyleSetGap.apply(
      <dynamic>[_nativePtr, gutter.index, value.value, value.unit.index]);

  @override
  LayoutValue getDimension(LayoutDimension dimension) => _layoutValueFromJs(
      _yogaStyleGetDimension.apply(<dynamic>[_nativePtr, dimension.index]));

  @override
  void setDimension(LayoutDimension dimension, LayoutValue value) =>
      _yogaStyleSetDimension.apply(<dynamic>[
        _nativePtr,
        dimension.index,
        value.value,
        value.unit.index
      ]);

  @override
  LayoutValue getMinDimension(LayoutDimension dimension) => _layoutValueFromJs(
      _yogaStyleGetMinDimension.apply(<dynamic>[_nativePtr, dimension.index]));

  @override
  void setMinDimension(LayoutDimension dimension, LayoutValue value) =>
      _yogaStyleSetMinDimension.apply(<dynamic>[
        _nativePtr,
        dimension.index,
        value.value,
        value.unit.index
      ]);

  @override
  LayoutValue getMaxDimension(LayoutDimension dimension) => _layoutValueFromJs(
      _yogaStyleGetMaxDimension.apply(<dynamic>[_nativePtr, dimension.index]));

  @override
  void setMaxDimension(LayoutDimension dimension, LayoutValue value) =>
      _yogaStyleSetMaxDimension.apply(<dynamic>[
        _nativePtr,
        dimension.index,
        value.value,
        value.unit.index
      ]);
}

class LayoutNodeWasm extends LayoutNode {
  int _nativePtr;
  LayoutNodeWasm(this._nativePtr);

  @override
  void dispose() {
    _disposeYogaNode.apply(<dynamic>[_nativePtr]);
    _callbackLookup.remove(_nativePtr);
    _nativePtr = 0;
  }

  @override
  void setStyle(LayoutStyle style) => _yogaNodeSetStyle
      .apply(<dynamic>[_nativePtr, (style as LayoutStyleWasm)._nativePtr]);

  @override
  LayoutNodeType get nodeType => LayoutNodeType
      .values[_yogaNodeGetType.apply(<dynamic>[_nativePtr]) as int];

  @override
  set nodeType(LayoutNodeType value) =>
      _yogaNodeSetType.apply(<dynamic>[_nativePtr, value.index]);

  @override
  void calculateLayout(double availableWidth, double availableHeight,
          LayoutDirection direction) =>
      _yogaNodeCalculateLayout.apply(
        <dynamic>[
          _nativePtr,
          availableWidth,
          availableHeight,
          direction.index,
        ],
      );

  @override
  Layout get layout {
    var data = _yogaNodeGetLayout.apply(<dynamic>[_nativePtr]) as js.JsObject;
    return _LayoutWasm(
      data['left'] as double,
      data['top'] as double,
      data['width'] as double,
      data['height'] as double,
    );
  }

  @override
  void clearChildren() => _yogaNodeClearChildren.apply(<dynamic>[_nativePtr]);

  @override
  void insertChild(LayoutNode node, int index) => _yogaNodeInsertChild
      .apply(<dynamic>[_nativePtr, (node as LayoutNodeWasm)._nativePtr, index]);

  // Store a hashmap to lookup pointer to layout nodes, necessary when using a
  // measure or baseline callback.
  static final HashMap<int, LayoutNodeWasm> _callbackLookup =
      HashMap<int, LayoutNodeWasm>();

  MeasureFunction? _measureFunction;
  @override
  MeasureFunction? get measureFunction => _measureFunction;

  @override
  set measureFunction(MeasureFunction? value) {
    if (value == _measureFunction) {
      return;
    }
    _measureFunction = value;
    if (value == null) {
      _callbackLookup.remove(_nativePtr);
      _yogaNodeClearMeasureFunc.apply(<dynamic>[_nativePtr]);
    } else {
      _yogaNodeSetMeasureFunc.apply(<dynamic>[
        _nativePtr,
        js.allowInterop(
          (int nativeLayout, double width, int widthMode, double height,
              int heightMode) {
            var layoutNode = _callbackLookup[nativeLayout];
            if (layoutNode == null) {
              return Float32List.fromList([0, 0]);
            }
            var size = value(
                layoutNode,
                width,
                LayoutMeasureMode.values[widthMode],
                height,
                LayoutMeasureMode.values[heightMode]);
            return Float32List.fromList([size.width, size.height]);
          },
        )
      ]);
      _callbackLookup[_nativePtr] = this;
    }
  }

  BaselineFunction? _baselineFunction;
  @override
  BaselineFunction? get baselineFunction => _baselineFunction;

  @override
  set baselineFunction(BaselineFunction? value) {
    if (value == _baselineFunction) {
      return;
    }
    _baselineFunction = value;
    if (value == null) {
      _yogaNodeClearBaselineFunc.apply(<dynamic>[_nativePtr]);
    } else {
      _yogaNodeSetBaselineFunc.apply(<dynamic>[
        _nativePtr,
        js.allowInterop(
          (int nativeLayout, double width, double height) {
            var layoutNode = _callbackLookup[nativeLayout];
            if (layoutNode == null) {
              return Float32List.fromList([0, 0]);
            }
            return value(layoutNode, width, height);
          },
        )
      ]);
      _callbackLookup[_nativePtr] = this;
    }
  }

  @override
  void markDirty() => _yogaNodeMarkDirty.apply(<dynamic>[_nativePtr]);
}

LayoutStyle makeLayoutStyle() =>
    LayoutStyleWasm(_makeYogaStyle.apply(<dynamic>[]) as int);

LayoutNode makeLayoutNode() =>
    LayoutNodeWasm(_makeYogaNode.apply(<dynamic>[]) as int);
