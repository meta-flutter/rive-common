import 'dart:ffi';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:ffi/ffi.dart';
import 'package:rive_common/platform.dart' as rive;
import 'package:rive_common/rive_taffy.dart';

final DynamicLibrary nativeLib = _loadLibrary();

DynamicLibrary _loadLibrary() {
  // Load library for peon
  if (rive.Platform.instance.isTesting || Platform.isLinux) {
    var paths = [
      '',
      '../../packages/rive_common/',
      '/app/packages/rive_common/',
    ];
    if (Platform.isMacOS) {
      for (final path in paths) {
        try {
          return DynamicLibrary.open(
            '${path}shared_lib/build/bin/debug/libtaffy_ffi.dylib',
          );

          // ignore: avoid_catching_errors
        } on ArgumentError catch (_) {}
      }
    } else if (Platform.isLinux) {
      for (final path in paths) {
        try {
          return DynamicLibrary.open(
            '${path}shared_lib/build/bin/debug/libtaffy_ffi.so',
          );
          // ignore: avoid_catching_errors
        } on ArgumentError catch (_) {}
      }
    }
  }
  return DynamicLibrary.process();
}

class TaffySliceNodeFFI extends Struct {
  external Pointer<TaffyNodeFFI> data;
  @UintPtr()
  external int length;
}

class TaffySliceTrackSizingFunctionFFI extends Struct
    implements TaffySliceTrackSizingFunction {
  external Pointer<TaffyTrackSizingFunctionFFI> dataPtr;

  @override
  @UintPtr()
  external int len;
}

class TaffySliceNonRepeatedTrackSizingFunctionFFI extends Struct
    implements TaffySliceNonRepeatedTrackSizingFunction {
  external Pointer<TaffyNonRepeatedTrackSizingFunctionFFI> dataPtr;

  @override
  @UintPtr()
  external int len;
}

final Pointer<Void> Function() taffyNew = nativeLib
    .lookup<NativeFunction<Pointer<Void> Function()>>('taffy_new')
    .asFunction();
final Pointer<Void> Function(Pointer<Void>) taffyRelease = nativeLib
    .lookup<NativeFunction<Pointer<Void> Function(Pointer<Void>)>>(
        'taffy_release')
    .asFunction();

final _TaffyStyleNativeStruct Function() taffyStyleDefault = nativeLib
    .lookup<NativeFunction<_TaffyStyleNativeStruct Function()>>(
        'taffy_style_default')
    .asFunction();

final TaffyResultFFI Function(
        Pointer<Void>, TaffyNodeFFI, _TaffyStyleNativeStruct) taffySetStyle =
    nativeLib
        .lookup<
            NativeFunction<
                TaffyResultFFI Function(Pointer<Void>, TaffyNodeFFI,
                    _TaffyStyleNativeStruct)>>('taffy_set_style')
        .asFunction();

final TaffyResultFFI Function(Pointer<Void>, TaffyNodeFFI, TaffySliceNodeFFI)
    taffySetChildren = nativeLib
        .lookup<
            NativeFunction<
                TaffyResultFFI Function(Pointer<Void>, TaffyNodeFFI,
                    TaffySliceNodeFFI)>>('taffy_set_children')
        .asFunction();

final TaffyResultLayoutFFI Function(Pointer<Void>, TaffyNodeFFI) taffyLayout =
    nativeLib
        .lookup<
            NativeFunction<
                TaffyResultLayoutFFI Function(
                    Pointer<Void>, TaffyNodeFFI)>>('taffy_layout')
        .asFunction();

final TaffyResultNodeFFI Function(Pointer<Void>, TaffyNodeFFI) taffyRemove =
    nativeLib
        .lookup<
            NativeFunction<
                TaffyResultNodeFFI Function(
                    Pointer<Void>, TaffyNodeFFI)>>('taffy_remove')
        .asFunction();

final TaffyResultFFI Function(Pointer<Void>, TaffyNodeFFI) taffyMarkDirty =
    nativeLib
        .lookup<
            NativeFunction<
                TaffyResultFFI Function(
                    Pointer<Void>, TaffyNodeFFI)>>('taffy_mark_dirty')
        .asFunction();

final TaffyResultNodeFFI Function(Pointer<Void>, _TaffyStyleNativeStruct)
    taffyNewLeaf = nativeLib
        .lookup<
            NativeFunction<
                TaffyResultNodeFFI Function(
                    Pointer<Void>, _TaffyStyleNativeStruct)>>('taffy_new_leaf')
        .asFunction();

final TaffyResultFFI Function(Pointer<Void>, TaffyNodeFFI, TaffySizeFFI)
    taffyComputeLayout = nativeLib
        .lookup<
            NativeFunction<
                TaffyResultFFI Function(Pointer<Void>, TaffyNodeFFI,
                    TaffySizeFFI)>>('taffy_compute_layout')
        .asFunction();

final TaffyResultFFI Function(Pointer<Void>) taffyEnableRounding = nativeLib
    .lookup<NativeFunction<TaffyResultFFI Function(Pointer<Void>)>>(
        'taffy_enable_rounding')
    .asFunction();

final TaffyResultFFI Function(Pointer<Void>) taffyDisableRounding = nativeLib
    .lookup<NativeFunction<TaffyResultFFI Function(Pointer<Void>)>>(
        'taffy_disable_rounding')
    .asFunction();

class TaffyNodeFFI extends Struct implements TaffyNode {
  @Uint64()
  external int pointer;
}

class TaffyErrorFFI extends Struct implements TaffyError {
  @Uint8()
  external int _tag;

  @override
  TaffyErrorTag get tag => TaffyErrorTag.values[_tag];

  @override
  external TaffyNodeFFI node;

  @override
  @UintPtr()
  external int childIndex;

  @override
  @UintPtr()
  external int childCount;
}

class TaffyLayoutResultDataFFI extends Union {
  external TaffyLayoutFFI ok;
  external TaffyErrorFFI err;
}

class TaffyLayoutFFI extends Struct implements TaffyLayout {
  @override
  @Uint32()
  external int order;

  @Float()
  external double width;
  @Float()
  external double height;
  @Float()
  external double x;
  @Float()
  external double y;

  @override
  ui.Offset get location => ui.Offset(x, y);

  @override
  ui.Size get size => ui.Size(width, height);
}

class TaffyNodeResultDataFFI extends Union {
  external TaffyNodeFFI ok;
  external TaffyErrorFFI err;
}

class TaffyResultLayoutFFI extends Struct implements TaffyResultLayout {
  @Uint8()
  external int _tag;

  @override
  TaffyResultTag get tag => TaffyResultTag.values[_tag];

  external TaffyLayoutResultDataFFI data;

  @override
  TaffyLayout? get layout => tag == TaffyResultTag.ok ? data.ok : null;

  @override
  TaffyError? get error => tag == TaffyResultTag.error ? data.err : null;
}

class TaffyResultNodeFFI extends Struct implements TaffyResultNode {
  @Uint8()
  external int _tag;

  @override
  TaffyResultTag get tag => TaffyResultTag.values[_tag];

  external TaffyNodeResultDataFFI data;

  @override
  TaffyNode? get node => tag == TaffyResultTag.ok ? data.ok : null;

  @override
  TaffyError? get error => tag == TaffyResultTag.error ? data.err : null;
}

class TaffyResultFFI extends Struct implements TaffyResult {
  @Uint8()
  external int _tag;

  @override
  TaffyResultTag get tag => TaffyResultTag.values[_tag];

  external TaffyErrorFFI err;

  @override
  TaffyError? get error => tag == TaffyResultTag.error ? err : null;
}

class TaffyDimensionFFI extends Struct implements TaffyDimension {
  @Uint8()
  external int _tag;

  @override
  TaffyDimensionTag get tag => TaffyDimensionTag.values[_tag];

  @override
  set tag(TaffyDimensionTag value) => _tag = value.index;

  @override
  @Float()
  external double value;
}

class TaffySizeFFI extends Struct implements TaffySize {
  @override
  external TaffyDimensionFFI width;

  @override
  external TaffyDimensionFFI height;
}

class TaffyRectFFI extends Struct implements TaffyRect {
  @override
  external TaffyDimensionFFI left;

  @override
  external TaffyDimensionFFI right;

  @override
  external TaffyDimensionFFI top;

  @override
  external TaffyDimensionFFI bottom;
}

class TaffyPointOverflowFFI extends Struct implements TaffyPointOverflow {
  @Uint8()
  external int _x;

  @Uint8()
  external int _y;

  @override
  TaffyOverflow get x => TaffyOverflow.values[_x];

  @override
  set x(TaffyOverflow value) => _x = value.index;

  @override
  TaffyOverflow get y => TaffyOverflow.values[_y];

  @override
  set y(TaffyOverflow value) => _y = value.index;
}

class TaffyOptionFloat32 extends Struct {
  @Uint8()
  external int tag;

  @Float()
  external double some;
}

class TaffyGridTrackRepetitionFFI extends Struct
    implements TaffyGridTrackRepetition {
  @Uint8()
  external int _tag;

  @override
  TaffyGridTrackRepetitionTag get tag =>
      TaffyGridTrackRepetitionTag.values[_tag];

  @override
  set tag(TaffyGridTrackRepetitionTag value) => _tag = value.index;

  @override
  @Uint8()
  external int count;
}

class TaffyTrackSizingFunctionFFI extends Struct
    implements TaffyTrackSizingFunction {
  @Uint8()
  external int _tag;

  @override
  TaffyTrackSizingFunctionTag get tag =>
      TaffyTrackSizingFunctionTag.values[_tag];

  @override
  set tag(TaffyTrackSizingFunctionTag value) => _tag = value.index;

  @override
  external TaffyTrackSizingUnionFFI func;
}

class TaffyTrackSizingUnionFFI extends Union implements TaffyTrackSizingUnion {
  @override
  external TaffyTrackSizingFunctionTaffyRepeatBodyFFI repeat;

  @override
  external TaffyNonRepeatedTrackSizingFunctionFFI single;
}

class TaffyMinTrackSizingFunctionFFI extends Struct
    implements TaffyMinTrackSizingFunction {
  @Uint8()
  external int _tag;

  @override
  TaffyMinTrackSizingFunctionTag get tag =>
      TaffyMinTrackSizingFunctionTag.values[_tag];

  @override
  set tag(TaffyMinTrackSizingFunctionTag value) => _tag = value.index;

  @override
  external TaffyDimensionFFI fixed;
}

class TaffyMaxTrackSizingFunctionFFI extends Struct
    implements TaffyMaxTrackSizingFunction {
  @Uint8()
  external int _tag;

  @override
  TaffyMaxTrackSizingFunctionTag get tag =>
      TaffyMaxTrackSizingFunctionTag.values[_tag];

  @override
  set tag(TaffyMaxTrackSizingFunctionTag value) => _tag = value.index;

  @override
  external TaffyMaxTrackSizingUnionFFI func;
}

class TaffyMaxTrackSizingUnionFFI extends Union
    implements TaffyMaxTrackSizingUnion {
  @override
  external TaffyDimensionFFI fixed;

  @override
  external TaffyDimensionFFI fitContent;

  @override
  @Float()
  external double fraction;
}

class TaffyNonRepeatedTrackSizingFunctionFFI extends Struct
    implements TaffyNonRepeatedTrackSizingFunction {
  @override
  external TaffyMinTrackSizingFunctionFFI min;

  @override
  external TaffyMaxTrackSizingFunctionFFI max;
}

class TaffyTrackSizingFunctionTaffyRepeatBodyFFI extends Struct
    implements TaffyTrackSizingFunctionTaffyRepeatBody {
  @override
  external TaffyGridTrackRepetitionFFI repeated;

  @override
  external TaffySliceNonRepeatedTrackSizingFunctionFFI nonRepeated;
}

class _TaffyStyleNativeStruct extends Struct {
  @Uint8()
  external int display;
  external TaffyPointOverflowFFI overflow;
  @Float()
  external double scrollbarWidth;
  @Uint8()
  external int position;
  external TaffyRectFFI inset;
  external TaffySizeFFI size;
  external TaffySizeFFI minSize;
  external TaffySizeFFI maxSize;
  external TaffyOptionFloat32 aspectRatio;
  external TaffyRectFFI margin;
  external TaffyRectFFI padding;
  external TaffyRectFFI border;
  @Uint8()
  external int alignItems;
  @Uint8()
  external int alignSelf;
  @Uint8()
  external int justifyItems;
  @Uint8()
  external int justifySelf;
  @Uint8()
  external int alignContent;
  @Uint8()
  external int justifyContent;
  external TaffySizeFFI gap;
  @Uint8()
  external int flexDirection;
  @Uint8()
  external int flexWrap;
  external TaffyDimensionFFI flexBasis;
  @Float()
  external double flexGrow;
  @Float()
  external double flexShrink;
  external TaffySliceTrackSizingFunctionFFI gridTemplateRows;
  external TaffySliceTrackSizingFunctionFFI gridTemplateColumns;
  external TaffySliceNonRepeatedTrackSizingFunctionFFI gridAutoRows;
  external TaffySliceNonRepeatedTrackSizingFunctionFFI gridAutoColumns;
  @Uint8()
  external int gridAutoFlow;
  external TaffyLineGridPlacementFFI gridRow;
  external TaffyLineGridPlacementFFI gridColumn;
}

class TaffyStyleFFI implements TaffyStyle {
  final _TaffyStyleNativeStruct nativeStruct;
  TaffyStyleFFI(this.nativeStruct);

  @override
  void dispose() {
    _releasePointers(_gridTemplateRowsPointers);
    _releasePointers(_gridTemplateColumnsPointers);
    _releasePointers(_gridAutoRowsPointers);
    _releasePointers(_gridAutoColumnsPointers);
  }

  @override
  TaffyDisplay get display => TaffyDisplay.values[nativeStruct.display];

  @override
  set display(TaffyDisplay value) => nativeStruct.display = value.index;

  @override
  double get scrollbarWidth => nativeStruct.scrollbarWidth;

  @override
  set scrollbarWidth(double value) => nativeStruct.scrollbarWidth = value;

  @override
  TaffyPointOverflow get overflow => nativeStruct.overflow;

  @override
  TaffyPosition get position => TaffyPosition.values[nativeStruct.position];

  @override
  set position(TaffyPosition value) => nativeStruct.position = value.index;

  @override
  TaffyRect get inset => nativeStruct.inset;

  @override
  TaffySize get size => nativeStruct.size;

  @override
  TaffySize get minSize => nativeStruct.minSize;

  @override
  TaffySize get maxSize => nativeStruct.maxSize;

  @override
  double? get aspectRatio =>
      nativeStruct.aspectRatio.tag == 0 ? nativeStruct.aspectRatio.some : null;

  @override
  set aspectRatio(double? value) {
    if (value == null) {
      nativeStruct.aspectRatio.tag = 1;
    } else {
      nativeStruct.aspectRatio.tag = 0;
      nativeStruct.aspectRatio.some = value;
    }
  }

  @override
  TaffyRect get margin => nativeStruct.margin;

  @override
  TaffyRect get padding => nativeStruct.padding;

  @override
  TaffyRect get border => nativeStruct.border;

  @override
  TaffyAlignItems get alignItems =>
      TaffyAlignItems.values[nativeStruct.alignItems];

  @override
  set alignItems(TaffyAlignItems value) =>
      nativeStruct.alignItems = value.index;

  @override
  TaffyAlignItems get alignSelf =>
      TaffyAlignItems.values[nativeStruct.alignSelf];

  @override
  set alignSelf(TaffyAlignItems value) => nativeStruct.alignSelf = value.index;

  @override
  TaffyAlignItems get justifyItems =>
      TaffyAlignItems.values[nativeStruct.justifyItems];

  @override
  set justifyItems(TaffyAlignItems value) =>
      nativeStruct.justifyItems = value.index;

  @override
  TaffyAlignItems get justifySelf =>
      TaffyAlignItems.values[nativeStruct.justifySelf];

  @override
  set justifySelf(TaffyAlignItems value) =>
      nativeStruct.justifySelf = value.index;

  @override
  TaffyAlignContent get alignContent =>
      TaffyAlignContent.values[nativeStruct.alignContent];

  @override
  set alignContent(TaffyAlignContent value) =>
      nativeStruct.alignContent = value.index;

  @override
  TaffyAlignContent get justifyContent =>
      TaffyAlignContent.values[nativeStruct.justifyContent];

  @override
  set justifyContent(TaffyAlignContent value) =>
      nativeStruct.justifyContent = value.index;

  @override
  TaffySizeFFI get gap => nativeStruct.gap;

  @override
  TaffyFlexDirection get flexDirection =>
      TaffyFlexDirection.values[nativeStruct.flexDirection];

  @override
  set flexDirection(TaffyFlexDirection value) =>
      nativeStruct.flexDirection = value.index;

  @override
  TaffyFlexWrap get flexWrap => TaffyFlexWrap.values[nativeStruct.flexWrap];

  @override
  set flexWrap(TaffyFlexWrap value) => nativeStruct.flexWrap = value.index;

  @override
  TaffyDimensionFFI get flexBasis => nativeStruct.flexBasis;

  @override
  double get flexGrow => nativeStruct.flexGrow;

  @override
  set flexGrow(double value) => nativeStruct.flexGrow = value;

  @override
  double get flexShrink => nativeStruct.flexShrink;

  @override
  set flexShrink(double value) => nativeStruct.flexShrink = value;

  @override
  TaffyGridAutoFlow get gridAutoFlow =>
      TaffyGridAutoFlow.values[nativeStruct.gridAutoFlow];

  @override
  set gridAutoFlow(TaffyGridAutoFlow value) =>
      nativeStruct.gridAutoFlow = value.index;

  @override
  TaffyLineGridPlacement get gridRow => nativeStruct.gridRow;

  @override
  TaffyLineGridPlacement get gridColumn => nativeStruct.gridColumn;

  void _releasePointers(List<Pointer> pointers) {
    pointers.forEach(calloc.free);
    pointers.clear();
  }

  List<Pointer> _gridTemplateRowsPointers = [];
  List<TaffyRepeatableTrackSizingModel> _gridTemplateRows = [];

  @override
  List<TaffyRepeatableTrackSizingModel> get gridTemplateRows =>
      _gridTemplateRows;

  @override
  set gridTemplateRows(List<TaffyRepeatableTrackSizingModel> rows) {
    _gridTemplateRows = rows;
    _releasePointers(_gridTemplateRowsPointers);
    _gridTemplateRowsPointers =
        _setGridTemplate(rows, nativeStruct.gridTemplateRows);
  }

  List<Pointer> _gridTemplateColumnsPointers = [];
  List<TaffyRepeatableTrackSizingModel> _gridTemplateColumns = [];

  @override
  List<TaffyRepeatableTrackSizingModel> get gridTemplateColumns =>
      _gridTemplateColumns;

  @override
  set gridTemplateColumns(List<TaffyRepeatableTrackSizingModel> columns) {
    _gridTemplateColumns = columns;
    _releasePointers(_gridTemplateColumnsPointers);
    _gridTemplateColumnsPointers =
        _setGridTemplate(columns, nativeStruct.gridTemplateColumns);
  }

  List<Pointer> _gridAutoRowsPointers = [];
  List<TaffySingleTrackSizingModel> _gridAutoRows = [];

  @override
  List<TaffySingleTrackSizingModel> get gridAutoRows => _gridAutoRows;

  @override
  set gridAutoRows(List<TaffySingleTrackSizingModel> rows) {
    _gridAutoRows = rows;
    _releasePointers(_gridAutoRowsPointers);
    _gridAutoRowsPointers = _setGridAuto(rows, nativeStruct.gridAutoRows);
  }

  List<Pointer> _gridAutoColumnsPointers = [];
  List<TaffySingleTrackSizingModel> _gridAutoColumns = [];

  @override
  List<TaffySingleTrackSizingModel> get gridAutoColumns => _gridAutoColumns;

  @override
  set gridAutoColumns(List<TaffySingleTrackSizingModel> columns) {
    _gridAutoColumns = columns;
    _releasePointers(_gridAutoColumnsPointers);
    _gridAutoColumnsPointers =
        _setGridAuto(columns, nativeStruct.gridAutoColumns);
  }

  List<Pointer> _setGridTemplate(List<TaffyRepeatableTrackSizingModel> models,
      TaffySliceTrackSizingFunctionFFI template) {
    List<Pointer> pointers = [];
    Pointer<TaffyTrackSizingFunctionFFI> ptr =
        calloc.allocate(sizeOf<TaffyTrackSizingFunctionFFI>() * models.length);
    pointers.add(ptr);
    for (int i = 0; i < models.length; i++) {
      var model = models[i];
      var sizingPtr = ptr[i];
      if (model.type == TaffyTrackSizingFunctionTag.repeat) {
        // If repeating, add all the track sizing functions
        sizingPtr.tag = TaffyTrackSizingFunctionTag.repeat;
        sizingPtr.func.repeat.repeated.tag =
            model.repeatType ?? TaffyGridTrackRepetitionTag.autoFill;
        sizingPtr.func.repeat.repeated.count = model.repeatCount;
        var funcLen = model.repeatModels.length;
        if (model.repeatModels.isNotEmpty) {
          Pointer<TaffyNonRepeatedTrackSizingFunctionFFI> ptrSizingFuncs =
              calloc.allocate(
                  sizeOf<TaffyNonRepeatedTrackSizingFunctionFFI>() * funcLen);
          for (int j = 0; j < model.repeatModels.length; j++) {
            var func = model.repeatModels[j];
            var funcPtr = ptrSizingFuncs[j];
            funcPtr.min.tag = func.minType;
            funcPtr.min.fixed.tag = func.minValueType;
            funcPtr.min.fixed.value = func.minValue;
            funcPtr.max.tag = func.maxType;
            funcPtr.max.func.fitContent.tag = func.maxValueType;
            funcPtr.max.func.fitContent.value =
                func.maxType == TaffyMaxTrackSizingFunctionTag.fitContent
                    ? func.maxValue
                    : 0;
            funcPtr.max.func.fixed.tag = func.maxValueType;
            funcPtr.max.func.fixed.value =
                func.maxType == TaffyMaxTrackSizingFunctionTag.fixed
                    ? func.maxValue
                    : 0;
            funcPtr.max.func.fraction =
                func.maxType == TaffyMaxTrackSizingFunctionTag.fraction
                    ? func.maxValue
                    : 0;
          }
          sizingPtr.func.repeat.nonRepeated.dataPtr = ptrSizingFuncs;
          sizingPtr.func.repeat.nonRepeated.len = funcLen;
          pointers.add(ptrSizingFuncs);
        }
      } else {
        var func = model.singleModel;
        if (func != null) {
          sizingPtr.tag = TaffyTrackSizingFunctionTag.single;
          sizingPtr.func.single.min.tag = func.minType;
          sizingPtr.func.single.min.fixed.tag = func.minValueType;
          sizingPtr.func.single.min.fixed.value = func.minValue;
          sizingPtr.func.single.max.tag = func.maxType;
          sizingPtr.func.single.max.func.fixed.tag = func.maxValueType;
          sizingPtr.func.single.max.func.fixed.value = func.maxValue;
        }
      }
    }
    template.dataPtr = ptr;
    template.len = models.length;
    return pointers;
  }

  List<Pointer> _setGridAuto(List<TaffySingleTrackSizingModel> models,
      TaffySliceNonRepeatedTrackSizingFunctionFFI auto) {
    List<Pointer> pointers = [];
    Pointer<TaffyNonRepeatedTrackSizingFunctionFFI> ptrAutoSizing =
        calloc.allocate(
            sizeOf<TaffyNonRepeatedTrackSizingFunctionFFI>() * models.length);
    pointers.add(ptrAutoSizing);
    for (int i = 0; i < models.length; i++) {
      var sizing = models[i];
      var sizingPtr = ptrAutoSizing[i];
      sizingPtr.min.tag = sizing.minType;
      sizingPtr.min.fixed.tag = sizing.minValueType;
      sizingPtr.min.fixed.value = sizing.minValue;
      sizingPtr.max.tag = sizing.maxType;
      sizingPtr.max.func.fixed.tag = sizing.maxValueType;
      sizingPtr.max.func.fixed.value = sizing.maxValue;
    }
    auto.dataPtr = ptrAutoSizing;
    auto.len = models.length;
    return pointers;
  }
}

class _SpanLineIndexUnion extends Union {
  @Uint16()
  external int span;

  @Int16()
  external int lineIndex;
}

class TaffyLineGridPlacementFFI extends Struct
    implements TaffyLineGridPlacement {
  @override
  external TaffyGridPlacementFFI start;

  @override
  external TaffyGridPlacementFFI end;
}

class TaffyGridPlacementFFI extends Struct implements TaffyGridPlacement {
  @Uint8()
  external int _tag;

  @override
  TaffyGridPlacementTag get tag => TaffyGridPlacementTag.values[_tag];

  @override
  set tag(TaffyGridPlacementTag value) => _tag = value.index;

  external _SpanLineIndexUnion _position;

  @override
  int get lineIndex => _position.lineIndex;

  @override
  set lineIndex(int value) => _position.lineIndex = value;

  @override
  int get span => _position.span;

  @override
  set span(int value) => _position.span = value;
}

class TaffySliceFFI extends Struct {
  external Pointer<Void> data;

  @UintPtr()
  external int len;
}

Pointer<TaffySizeFFI> _makeComputeLayoutSize() {
  var ptr = calloc.allocate<TaffySizeFFI>(sizeOf<TaffySizeFFI>());
  // Hacky, this is actually equivalent to TaffyAvailableSpace_MaxContent
  ptr.ref.width.tag = TaffyDimensionTag.auto;
  ptr.ref.height.tag = TaffyDimensionTag.auto;
  return ptr;
}

class TaffyFFI extends Taffy {
  final Pointer<Void> taffyPtr;
  static final Pointer<TaffySizeFFI> _computeSize = _makeComputeLayoutSize();

  TaffyFFI() : taffyPtr = taffyNew() {
    // print('instanced taffy: $taffyPtr');

    // var defaultStyle = taffyStyleDefault();
    // print('Default style: ${defaultStyle.display}');
    // print('Position ${defaultStyle.position}');
    // print('Inset Left: ${defaultStyle.inset.left.tag}');
    // print(
    // 'Size: ${defaultStyle.size.width.tag} ${defaultStyle.size.width.value} x
    // ${defaultStyle.size.height.tag} ${defaultStyle.size.height.value}');
  }

  @override
  void dispose() => taffyRelease(taffyPtr);

  @override
  TaffyStyle defaultStyle() => TaffyStyleFFI(taffyStyleDefault());

  @override
  TaffyResult computeLayout({required covariant TaffyNodeFFI node}) =>
      taffyComputeLayout(taffyPtr, node, _computeSize.ref);

  @override
  TaffyResultNode node({TaffyStyle? style}) {
    style ??= defaultStyle();
    return taffyNewLeaf(taffyPtr, (style as TaffyStyleFFI).nativeStruct);
  }

  @override
  TaffyResultNode remove({required covariant TaffyNodeFFI node}) =>
      taffyRemove(taffyPtr, node);

  @override
  TaffyResult markDirty({required covariant TaffyNodeFFI node}) =>
      taffyMarkDirty(taffyPtr, node);

  @override
  TaffyResult setChildren(
      {required covariant TaffyNodeFFI parent,
      required List<TaffyNode> children}) {
    Pointer<TaffyNodeFFI> childrenPtr =
        calloc.allocate(children.length * sizeOf<TaffyNodeFFI>());
    int childIndex = 0;
    for (final child in children.cast<TaffyNodeFFI>()) {
      childrenPtr[childIndex++] = child;
    }

    var slice = calloc.allocate<TaffySliceNodeFFI>(sizeOf<TaffySliceNodeFFI>());
    slice.ref.data = childrenPtr;
    slice.ref.length = children.length;

    var result = taffySetChildren(taffyPtr, parent, slice.ref);

    calloc.free(childrenPtr);
    calloc.free(slice);

    return result;
  }

  @override
  TaffyResult setStyle({
    required covariant TaffyNodeFFI node,
    required covariant TaffyStyleFFI style,
  }) =>
      taffySetStyle(taffyPtr, node, style.nativeStruct);

  @override
  TaffyResultLayout layout({required covariant TaffyNodeFFI node}) =>
      taffyLayout(taffyPtr, node);

  @override
  TaffyResult enableRounding() => taffyEnableRounding(taffyPtr);

  @override
  TaffyResult disableRounding() => taffyDisableRounding(taffyPtr);
}

Taffy makeTaffy() => TaffyFFI();
