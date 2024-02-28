import 'dart:ui';

import 'src/rive_taffy_ffi.dart'
    if (dart.library.html) 'src/rive_taffy_wasm.dart';

enum TaffyOverflow { visible, hidden, scroll }

enum TaffyAlignItems {
  none,
  start,
  end,
  flexStart,
  flexEnd,
  center,
  baseLine,
  stretch,
}

enum TaffyAlignContent {
  none,
  start,
  end,
  flexStart,
  flexEnd,
  center,
  stretch,
  spaceBetween,
  spaceEvenly,
  spaceAround,
}

enum TaffyFlexDirection {
  row,
  column,
  rowReverse,
  columnReverse,
}

enum TaffyFlexWrap {
  noWrap,
  wrap,
  wrapReverse,
}

enum TaffyPosition {
  relative,
  absolute,
}

enum TaffyResultTag {
  ok,
  error,
}

enum TaffyDimensionTag {
  points,
  percent,
  auto,
}

enum TaffyDisplay {
  flex,
  grid,
  none,
}

enum TaffyGridAutoFlow {
  row,
  column,
  rowDense,
  columnDense,
}

enum TaffyGridPlacementTag {
  auto,
  line,
  span,
}

enum TaffyTrackSizingFunctionTag {
  single,
  repeat,
}

enum TaffyGridTrackRepetitionTag {
  autoFill,
  autoFit,
  count,
}

enum TaffyMinTrackSizingFunctionTag {
  fixed,
  minContent,
  maxContent,
  auto,
}

enum TaffyMaxTrackSizingFunctionTag {
  fixed,
  minContent,
  maxContent,
  fitContent,
  auto,
  fraction,
}

abstract class TaffyPointOverflow {
  TaffyOverflow get x;
  TaffyOverflow get y;
  set x(TaffyOverflow value);
  set y(TaffyOverflow value);
}

abstract class TaffyLineGridPlacement {
  TaffyGridPlacement get start;
  TaffyGridPlacement get end;
}

abstract class TaffyGridPlacement {
  TaffyGridPlacementTag get tag;
  set tag(TaffyGridPlacementTag value);

  int get lineIndex;
  set lineIndex(int value);

  int get span;
  set span(int value);
}

abstract class TaffyTrackSizingFunction {
  TaffyTrackSizingFunctionTag get tag;
  set tag(TaffyTrackSizingFunctionTag value);

  TaffyTrackSizingUnion get func;
}

abstract class TaffyTrackSizingUnion {
  TaffyTrackSizingFunctionTaffyRepeatBody get repeat;

  TaffyNonRepeatedTrackSizingFunction get single;
}

abstract class TaffyTrackSizingFunctionTaffyRepeatBody {
  TaffyGridTrackRepetition get repeated;

  TaffySliceNonRepeatedTrackSizingFunction get nonRepeated;
}

abstract class TaffyGridTrackRepetition {
  TaffyGridTrackRepetitionTag get tag;
  set tag(TaffyGridTrackRepetitionTag value);

  int get count;
  set count(int value);
}

abstract class TaffyMinTrackSizingFunction {
  TaffyMinTrackSizingFunctionTag get tag;
  set tag(TaffyMinTrackSizingFunctionTag value);

  TaffyDimension get fixed;
}

abstract class TaffyMaxTrackSizingFunction {
  TaffyMaxTrackSizingFunctionTag get tag;
  set tag(TaffyMaxTrackSizingFunctionTag value);

  TaffyMaxTrackSizingUnion get func;
}

abstract class TaffyMaxTrackSizingUnion {
  TaffyDimension get fixed;

  TaffyDimension get fitContent;

  double get fraction;
  set fraction(double value);
}

abstract class TaffyNonRepeatedTrackSizingFunction {
  TaffyMinTrackSizingFunction get min;

  TaffyMaxTrackSizingFunction get max;
}

enum TaffyErrorTag {
  /// The parent Node does not have a child at child_index. It only has
  /// child_count children
  childIndexOutOfBounds,

  /// The parent Node was not found in the Taffy instance.
  invalidParentNode,

  /// The child Node was not found in the Taffy instance.
  invalidChildNode,

  /// The supplied Node was not found in the Taffy instance.
  invalidInputNode,

  nullPointer,
}

/// A tree of UI Nodes, suitable for UI layout
abstract class Taffy {
  /// Creates and adds a new unattached leaf node to the tree, and returns the
  /// Node of the new node
  TaffyResultNode node({TaffyStyle? style});

  /// Creates a deafult styling object.
  TaffyStyle defaultStyle();

  /// Remove a specific [TaffyNode] from the tree and drops it
  ///
  /// Returns the id of the node removed.
  TaffyResultNode remove({required TaffyNode node});

  /// Mark a node as dirty to tell Taffy that something has changed and it needs
  /// to be recomputed.
  ///
  /// Commonly done if the style of the node has changed.
  TaffyResult markDirty({required TaffyNode node});

  /// Directly sets the children of the supplied parent
  TaffyResult setChildren(
      {required TaffyNode parent, required List<TaffyNode> children});

  /// Sets the Style of the provided node
  TaffyResult setStyle({
    required TaffyNode node,
    required TaffyStyle style,
  });

  /// Updates the stored layout of the provided node and its children
  TaffyResult computeLayout({required TaffyNode node});

  /// Gets the stored layout of the provided node
  TaffyResultLayout layout({required TaffyNode node});

  static Taffy make() => makeTaffy();

  bool _rounding = true;
  bool get rounding => _rounding;
  set rounding(bool value) {
    if (_rounding != value) {
      _rounding = value;
    }
  }

  TaffyResult enableRounding();
  TaffyResult disableRounding();

  void dispose();
}

/// The parent Node does not have a child at child_index. It only has
/// child_count children
class TaffyChildIndexOutOfBounds {
  /// The parent node whose child was being looked up
  final TaffyNode parent;

  /// The index that was looked up
  final int childIndex;

  /// The total number of children the parent has
  final int childCount;

  const TaffyChildIndexOutOfBounds({
    required this.parent,
    required this.childIndex,
    required this.childCount,
  });
}

/// An error that occurs while trying to access or modify a Node’s children by
/// index.
abstract class TaffyError {
  TaffyErrorTag get tag;

  /// Parent node when tag is TaffyErrorTag.childIndexOutOfBounds otherwise the
  /// node specified by tag.
  TaffyNode get node;

  /// The index that was looked up. Only valid when
  /// TaffyErrorTag.childIndexOutOfBounds.
  int get childIndex;

  /// The total number of children the parent has. Only valid when
  /// TaffyErrorTag.childIndexOutOfBounds.
  int get childCount;
}

abstract class TaffyResult {
  TaffyResultTag get tag;
  TaffyError? get error;
}

abstract class TaffyResultNode extends TaffyResult {
  TaffyNode? get node;
}

/// A node in a layout.
abstract class TaffyNode {}

abstract class TaffyDimension {
  TaffyDimensionTag get tag;
  set tag(TaffyDimensionTag value);

  double get value;
  set value(double value);
}

abstract class TaffySize {
  TaffyDimension get width;
  TaffyDimension get height;
}

abstract class TaffyRect {
  TaffyDimension get left;
  TaffyDimension get right;
  TaffyDimension get top;
  TaffyDimension get bottom;
}

abstract class TaffyStyle {
  TaffyDisplay get display;
  set display(TaffyDisplay value);

  TaffyPointOverflow get overflow;

  double get scrollbarWidth;
  set scrollbarWidth(double value);

  TaffyPosition get position;
  set position(TaffyPosition value);

  TaffyRect get inset;

  TaffySize get size;

  TaffySize get maxSize;

  TaffySize get minSize;

  double? get aspectRatio;
  set aspectRatio(double? value);

  TaffyRect get margin;

  TaffyRect get padding;

  TaffyRect get border;

  TaffyAlignItems get alignItems;
  set alignItems(TaffyAlignItems value);

  TaffyAlignItems get alignSelf;
  set alignSelf(TaffyAlignItems value);

  TaffyAlignItems get justifyItems;
  set justifyItems(TaffyAlignItems value);

  TaffyAlignItems get justifySelf;
  set justifySelf(TaffyAlignItems value);

  TaffyAlignContent get alignContent;
  set alignContent(TaffyAlignContent value);

  TaffyAlignContent get justifyContent;
  set justifyContent(TaffyAlignContent value);

  TaffySize get gap;

  TaffyFlexDirection get flexDirection;
  set flexDirection(TaffyFlexDirection value);

  TaffyFlexWrap get flexWrap;
  set flexWrap(TaffyFlexWrap value);

  TaffyDimension get flexBasis;

  double get flexGrow;
  set flexGrow(double value);

  double get flexShrink;
  set flexShrink(double value);

  TaffyGridAutoFlow get gridAutoFlow;
  set gridAutoFlow(TaffyGridAutoFlow value);
  TaffyLineGridPlacement get gridRow;
  TaffyLineGridPlacement get gridColumn;

  List<TaffyRepeatableTrackSizingModel> get gridTemplateRows;
  set gridTemplateRows(List<TaffyRepeatableTrackSizingModel> rows);

  List<TaffyRepeatableTrackSizingModel> get gridTemplateColumns;
  set gridTemplateColumns(List<TaffyRepeatableTrackSizingModel> columns);

  List<TaffySingleTrackSizingModel> get gridAutoRows;
  set gridAutoRows(List<TaffySingleTrackSizingModel> rows);

  List<TaffySingleTrackSizingModel> get gridAutoColumns;
  set gridAutoColumns(List<TaffySingleTrackSizingModel> columns);

  void dispose();
}

/// The final result of a layout algorithm for a single Node.
abstract class TaffyLayout {
  /// The relative ordering of the node
  ///
  /// Nodes with a higher order should be rendered on top of those with a lower
  /// order. This is effectively a topological sort of each tree.
  int get order;

  /// The width and height of the node
  Size get size;

  /// The bottom-left corner of the node
  Offset get location;
}

abstract class TaffyResultLayout extends TaffyResult {
  TaffyLayout? get layout;
}

abstract class TaffySliceTrackSizingFunction {
  int get len;
}

abstract class TaffySliceNonRepeatedTrackSizingFunction {
  int get len;
}

class TaffySingleTrackSizingModel {
  TaffyMinTrackSizingFunctionTag minType;
  TaffyDimensionTag minValueType;
  double minValue;
  TaffyMaxTrackSizingFunctionTag maxType;
  TaffyDimensionTag maxValueType;
  double maxValue;

  TaffySingleTrackSizingModel(
      {required this.minType,
      required this.minValueType,
      required this.minValue,
      required this.maxType,
      required this.maxValueType,
      required this.maxValue});
}

class TaffyRepeatableTrackSizingModel {
  TaffyTrackSizingFunctionTag type;
  TaffySingleTrackSizingModel? singleModel;
  TaffyGridTrackRepetitionTag? repeatType;
  int repeatCount = 0;
  List<TaffySingleTrackSizingModel> repeatModels = [];

  TaffyRepeatableTrackSizingModel({required this.type});
}
