import 'dart:js' as js;
import 'dart:typed_data';
import 'dart:ui';

import 'package:rive_common/rive_taffy.dart';

late js.JsFunction _taffyNew;
late js.JsFunction _taffyRelease;
late js.JsFunction _taffySetStyle;
late js.JsFunction _taffyNewLeaf;
late js.JsFunction _taffyRemove;
late js.JsFunction _taffyMarkDirty;
late js.JsFunction _taffySetChildren;
late js.JsFunction _taffyComputeLayout;
late js.JsFunction _taffyLayout;
late js.JsFunction _taffyEnableRounding;
late js.JsFunction _taffyDisableRounding;
late js.JsFunction _taffyStyleDefault;

class TaffyNodeWasm extends TaffyNode {
  final int pointer;

  TaffyNodeWasm(this.pointer);
  factory TaffyNodeWasm.fromJS(js.JsObject obj) =>
      TaffyNodeWasm(obj['pointer'] as int);
}

class TaffyErrorWasm extends TaffyError {
  final js.JsObject jsObject;
  TaffyErrorWasm(this.jsObject);

  @override
  int get childCount {
    var dataObj = jsObject['data'] as js.JsObject;
    return dataObj['childCount'] as int;
  }

  @override
  int get childIndex {
    var dataObj = jsObject['data'] as js.JsObject;
    return dataObj['childIndex'] as int;
  }

  @override
  TaffyNode get node {
    var dataObj = jsObject['data'] as js.JsObject;
    return TaffyNodeWasm.fromJS(dataObj['node'] as js.JsObject);
  }

  @override
  TaffyErrorTag get tag => TaffyErrorTag.values[jsObject['tag'] as int];
}

class TaffyResultNodeWasm extends TaffyResultNode {
  final js.JsObject jsObject;
  TaffyResultNodeWasm(this.jsObject);

  @override
  TaffyError? get error {
    if (tag == TaffyResultTag.error && jsObject['error'] is js.JsObject) {
      return TaffyErrorWasm(jsObject['error'] as js.JsObject);
    }
    return null;
  }

  @override
  TaffyNode? get node {
    if (tag == TaffyResultTag.ok && jsObject['node'] is js.JsObject) {
      return TaffyNodeWasm.fromJS(jsObject['node'] as js.JsObject);
    }
    return null;
  }

  @override
  TaffyResultTag get tag => TaffyResultTag.values[jsObject['tag'] as int];
}

class TaffyResultWasm extends TaffyResult {
  final js.JsObject jsObject;
  TaffyResultWasm(this.jsObject);

  @override
  TaffyError? get error {
    if (tag == TaffyResultTag.error && jsObject['error'] is js.JsObject) {
      return TaffyErrorWasm(jsObject['error'] as js.JsObject);
    }
    return null;
  }

  @override
  TaffyResultTag get tag => TaffyResultTag.values[jsObject['tag'] as int];
}

class TaffyDimensionWasm extends TaffyDimension {
  final js.JsObject jsObject;
  TaffyDimensionWasm(this.jsObject);

  @override
  TaffyDimensionTag get tag => TaffyDimensionTag.values[jsObject['tag'] as int];

  @override
  set tag(TaffyDimensionTag value) => jsObject['tag'] = value.index;

  @override
  double get value => jsObject['value'] as double;

  @override
  set value(double v) => jsObject['value'] = v;
}

class TaffyRectWasm extends TaffyRect {
  final js.JsObject jsObject;
  TaffyRectWasm(this.jsObject);

  @override
  TaffyDimension get bottom =>
      TaffyDimensionWasm(jsObject['bottom'] as js.JsObject);

  @override
  TaffyDimension get left =>
      TaffyDimensionWasm(jsObject['left'] as js.JsObject);

  @override
  TaffyDimension get right =>
      TaffyDimensionWasm(jsObject['right'] as js.JsObject);

  @override
  TaffyDimension get top => TaffyDimensionWasm(jsObject['top'] as js.JsObject);
}

class TaffyPointOverflowWasm extends TaffyPointOverflow {
  final js.JsObject jsObject;
  TaffyPointOverflowWasm(this.jsObject);

  @override
  TaffyOverflow get x => TaffyOverflow.values[jsObject['x'] as int];

  @override
  set x(TaffyOverflow value) => jsObject['x'] = value;

  @override
  TaffyOverflow get y => TaffyOverflow.values[jsObject['y'] as int];

  @override
  set y(TaffyOverflow value) => jsObject['y'] = value;
}

class TaffyStyleWasm extends TaffyStyle {
  final js.JsObject jsObject;
  TaffyStyleWasm(this.jsObject);

  @override
  TaffyAlignContent get alignContent =>
      TaffyAlignContent.values[jsObject['alignContent'] as int];

  @override
  set alignContent(TaffyAlignContent value) {
    jsObject['alignContent'] = value.index;
  }

  @override
  TaffyAlignItems get alignItems =>
      TaffyAlignItems.values[jsObject['alignItems'] as int];

  @override
  set alignItems(TaffyAlignItems value) {
    jsObject['alignItems'] = value.index;
  }

  @override
  TaffyAlignItems get alignSelf =>
      TaffyAlignItems.values[jsObject['alignSelf'] as int];

  @override
  set alignSelf(TaffyAlignItems value) {
    jsObject['alignSelf'] = value.index;
  }

  @override
  double? get aspectRatio {
    var aspectRatioObject = jsObject['aspectRatio'] as js.JsObject;
    if (aspectRatioObject['tag'] == 0) {
      return aspectRatioObject['value'] as double;
    }
    return null;
  }

  @override
  set aspectRatio(double? value) {
    var aspectRatioObject = jsObject['aspectRatio'] as js.JsObject;
    if (value == null) {
      aspectRatioObject['tag'] = 1;
    } else {
      aspectRatioObject['tag'] = 0;
      aspectRatioObject['value'] = value;
    }
  }

  @override
  TaffyDisplay get display => TaffyDisplay.values[jsObject['display'] as int];

  @override
  set display(TaffyDisplay value) => jsObject['display'] = value.index;

  @override
  TaffyFlexDirection get flexDirection =>
      TaffyFlexDirection.values[jsObject['flexDirection'] as int];

  @override
  set flexDirection(TaffyFlexDirection value) =>
      jsObject['flexDirection'] = value.index;

  @override
  double get flexGrow => jsObject['flexGrow'] as double;

  @override
  set flexGrow(double value) => jsObject['flexGrow'] = value;

  @override
  double get flexShrink => jsObject['flexShrink'] as double;

  @override
  set flexShrink(double value) => jsObject['flexShrink'] = value;

  @override
  TaffyFlexWrap get flexWrap =>
      TaffyFlexWrap.values[jsObject['flexWrap'] as int];

  @override
  set flexWrap(TaffyFlexWrap value) => jsObject['flexWrap'] = value.index;

  @override
  List<TaffySingleTrackSizingModel> get gridAutoColumns => [];

  // TODO: grid for wasm
  @override
  TaffyAlignContent get justifyContent =>
      TaffyAlignContent.values[jsObject['justifyContent'] as int];

  @override
  set justifyContent(TaffyAlignContent value) =>
      jsObject['justifyContent'] = value.index;

  @override
  TaffyAlignItems get justifyItems =>
      TaffyAlignItems.values[jsObject['justifyItems'] as int];

  @override
  set justifyItems(TaffyAlignItems value) =>
      jsObject['justifyItems'] = value.index;

  @override
  TaffyAlignItems get justifySelf =>
      TaffyAlignItems.values[jsObject['justifySelf'] as int];

  @override
  set justifySelf(TaffyAlignItems value) =>
      jsObject['justifySelf'] = value.index;

  @override
  TaffyPosition get position =>
      TaffyPosition.values[jsObject['position'] as int];

  @override
  set position(TaffyPosition value) => jsObject['position'] = value.index;

  @override
  double get scrollbarWidth => jsObject['scrollbarWidth'] as double;

  @override
  set scrollbarWidth(double value) => jsObject['scrollbarWidth'] = value;

  @override
  TaffyRect get border => TaffyRectWasm(jsObject['border'] as js.JsObject);

  @override
  void dispose() {}

  @override
  TaffyDimension get flexBasis =>
      TaffyDimensionWasm(jsObject['flexBasis'] as js.JsObject);

  @override
  TaffySize get gap => TaffySizeWasm(jsObject['gap'] as js.JsObject);

  @override
  TaffyRect get inset => TaffyRectWasm(jsObject['inset'] as js.JsObject);

  @override
  TaffyRect get margin => TaffyRectWasm(jsObject['margin'] as js.JsObject);

  @override
  TaffySize get maxSize => TaffySizeWasm(jsObject['maxSize'] as js.JsObject);

  @override
  TaffySize get minSize => TaffySizeWasm(jsObject['minSize'] as js.JsObject);

  @override
  TaffyPointOverflow get overflow =>
      TaffyPointOverflowWasm(jsObject['overflow'] as js.JsObject);

  @override
  TaffyRect get padding => TaffyRectWasm(jsObject['padding'] as js.JsObject);

  @override
  TaffySize get size => TaffySizeWasm(jsObject['size'] as js.JsObject);

  // TODO: GRID for WASM!!
  @override
  set gridAutoColumns(List<TaffySingleTrackSizingModel> value) {}

  @override
  TaffyGridAutoFlow get gridAutoFlow => TaffyGridAutoFlow.column;

  @override
  set gridAutoFlow(TaffyGridAutoFlow value) {}

  @override
  List<TaffySingleTrackSizingModel> get gridAutoRows => [];

  @override
  set gridAutoRows(List<TaffySingleTrackSizingModel> values) {}

  @override
  List<TaffyRepeatableTrackSizingModel> get gridTemplateColumns => [];

  @override
  set gridTemplateColumns(List<TaffyRepeatableTrackSizingModel> value) {}

  @override
  List<TaffyRepeatableTrackSizingModel> get gridTemplateRows => [];

  @override
  set gridTemplateRows(List<TaffyRepeatableTrackSizingModel> value) {}

  @override
  TaffyLineGridPlacement get gridColumn => TaffyLineGridPlacementEmpty();

  @override
  TaffyLineGridPlacement get gridRow => TaffyLineGridPlacementEmpty();
}

class TaffyGridPlacementEmpty extends TaffyGridPlacement {
  @override
  int lineIndex = 0;

  @override
  int span = 0;

  @override
  TaffyGridPlacementTag tag = TaffyGridPlacementTag.auto;
}

class TaffyLineGridPlacementEmpty extends TaffyLineGridPlacement {
  @override
  TaffyGridPlacement get end => TaffyGridPlacementEmpty();

  @override
  TaffyGridPlacement get start => TaffyGridPlacementEmpty();
}

class TaffyLayoutWasm extends TaffyLayout {
  final js.JsObject jsObject;
  TaffyLayoutWasm(this.jsObject);

  @override
  Offset get location {
    var jsobj = jsObject['location'] as js.JsObject;
    return Offset(jsobj['x'] as double, jsobj['y'] as double);
  }

  @override
  int get order => jsObject['order'] as int;

  @override
  Size get size {
    var jsobj = jsObject['size'] as js.JsObject;
    return Size(jsobj['width'] as double, jsobj['height'] as double);
  }
}

class TaffyResultLayoutWasm extends TaffyResultLayout {
  final js.JsObject jsObject;
  TaffyResultLayoutWasm(this.jsObject);

  @override
  TaffyError? get error {
    if (tag == TaffyResultTag.error && jsObject['error'] is js.JsObject) {
      return TaffyErrorWasm(jsObject['error'] as js.JsObject);
    }
    return null;
  }

  @override
  TaffyLayout? get layout {
    if (tag == TaffyResultTag.ok && jsObject['layout'] is js.JsObject) {
      return TaffyLayoutWasm(jsObject['layout'] as js.JsObject);
    }
    return null;
  }

  @override
  TaffyResultTag get tag => TaffyResultTag.values[jsObject['tag'] as int];
}

class TaffySizeWasm extends TaffySize {
  final js.JsObject jsObject;
  TaffySizeWasm(this.jsObject);

  @override
  TaffyDimension get height =>
      TaffyDimensionWasm(jsObject['height'] as js.JsObject);

  @override
  TaffyDimension get width =>
      TaffyDimensionWasm(jsObject['width'] as js.JsObject);
}

class TaffyWasm extends Taffy {
  static void init(js.JsObject module) {
    _taffyNew = module['taffyNew'] as js.JsFunction;
    _taffyRelease = module['taffyRelease'] as js.JsFunction;
    _taffySetStyle = module['taffySetStyle'] as js.JsFunction;
    _taffyNewLeaf = module['taffyNewLeaf'] as js.JsFunction;
    _taffyRemove = module['taffyRemove'] as js.JsFunction;
    _taffyMarkDirty = module['taffyMarkDirty'] as js.JsFunction;
    _taffySetChildren = module['taffySetChildren'] as js.JsFunction;
    _taffyComputeLayout = module['taffyComputeLayout'] as js.JsFunction;
    _taffyLayout = module['taffyLayout'] as js.JsFunction;
    _taffyEnableRounding = module['taffyEnableRounding'] as js.JsFunction;
    _taffyDisableRounding = module['taffyDisableRounding'] as js.JsFunction;
    _taffyStyleDefault = module['taffyStyleDefault'] as js.JsFunction;
  }

  final int _taffyPtr;
  TaffyWasm() : _taffyPtr = _taffyNew.apply(<dynamic>[]) as int;

  @override
  TaffyResult computeLayout({required TaffyNode node}) {
    var result = _taffyComputeLayout.apply(<dynamic>[
      _taffyPtr,
      (node as TaffyNodeWasm).pointer,
    ]) as js.JsObject;
    return TaffyResultWasm(result);
  }

  @override
  TaffyStyle defaultStyle() => TaffyStyleWasm(
        _taffyStyleDefault.apply(<dynamic>[]) as js.JsObject,
      );

  @override
  TaffyResult disableRounding() => TaffyResultWasm(
        _taffyDisableRounding.apply(<dynamic>[_taffyPtr]) as js.JsObject,
      );

  @override
  void dispose() => _taffyRelease.apply(<dynamic>[_taffyPtr]);

  @override
  TaffyResult enableRounding() => TaffyResultWasm(
        _taffyEnableRounding.apply(<dynamic>[]) as js.JsObject,
      );

  @override
  TaffyResultLayout layout({required TaffyNode node}) => TaffyResultLayoutWasm(
        _taffyLayout.apply(
          <dynamic>[
            _taffyPtr,
            (node as TaffyNodeWasm).pointer,
          ],
        ) as js.JsObject,
      );

  @override
  TaffyResult markDirty({required TaffyNode node}) => TaffyResultWasm(
        _taffyMarkDirty
                .apply(<dynamic>[_taffyPtr, (node as TaffyNodeWasm).pointer])
            as js.JsObject,
      );

  @override
  TaffyResultNode node({TaffyStyle? style}) {
    style ??= defaultStyle();
    return TaffyResultNodeWasm(
      _taffyNewLeaf
              .apply(<dynamic>[_taffyPtr, (style as TaffyStyleWasm).jsObject])
          as js.JsObject,
    );
  }

  @override
  TaffyResultNode remove({required TaffyNode node}) => TaffyResultNodeWasm(
        _taffyRemove
                .apply(<dynamic>[_taffyPtr, (node as TaffyNodeWasm).pointer])
            as js.JsObject,
      );

  @override
  TaffyResult setChildren(
      {required TaffyNode parent, required List<TaffyNode> children}) {
    return TaffyResultWasm(
      _taffySetChildren.apply(
        <dynamic>[
          _taffyPtr,
          (parent as TaffyNodeWasm).pointer,
          Uint32List.fromList(
            children
                .cast<TaffyNodeWasm>()
                .map((child) => child.pointer)
                .toList(),
          ),
        ],
      ) as js.JsObject,
    );
  }

  @override
  TaffyResult setStyle({required TaffyNode node, required TaffyStyle style}) =>
      TaffyResultWasm(
        _taffySetStyle.apply(
          <dynamic>[
            _taffyPtr,
            (node as TaffyNodeWasm).pointer,
            (style as TaffyStyleWasm).jsObject,
          ],
        ) as js.JsObject,
      );
}

Taffy makeTaffy() => TaffyWasm();
