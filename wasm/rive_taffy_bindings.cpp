#include "taffy.h"

#include <emscripten.h>
#include <emscripten/bind.h>
#include <emscripten/val.h>
#include <stdint.h>
#include <stdio.h>

using namespace emscripten;

using WasmPtr = uint32_t;
using WasmTaffyNode = uint32_t;

WasmPtr taffyNew() { return (WasmPtr)taffy_new(); }
void taffyRelease(WasmPtr taffy) { return taffy_release((Taffy*)taffy); }
TaffyResult_Unit taffySetStyle(WasmPtr taffy, WasmTaffyNode node, TaffyStyle style)
{
    return taffy_set_style((Taffy*)taffy, {node}, style);
}
TaffyResult_NodeId taffyNewLeaf(WasmPtr taffy, TaffyStyle style)
{
    return taffy_new_leaf((Taffy*)taffy, style);
}
TaffyResult_NodeId taffyRemove(WasmPtr taffy, WasmTaffyNode node)
{
    return taffy_remove((Taffy*)taffy, {node});
}
TaffyResult_Unit taffyMarkDirty(WasmPtr taffy, WasmTaffyNode node)
{
    return taffy_mark_dirty((Taffy*)taffy, {node});
}
TaffyResult_Unit taffySetChildren(WasmPtr taffy, WasmTaffyNode node, emscripten::val childrenList)
{
    std::vector<uint32_t> childNodeIds(childrenList["length"].as<unsigned>());
    {
        emscripten::val memoryView{
            emscripten::typed_memory_view(childNodeIds.size(), childNodeIds.data())};
        memoryView.call<void>("set", childrenList);
    }

    std::vector<TaffyNodeId> childNodes;
    childNodes.reserve(childNodeIds.size());

    for (auto id : childNodeIds)
    {
        childNodes.push_back({id});
    }
    return taffy_set_children((Taffy*)taffy,
                              {node},
                              {childNodes.data(), (uintptr_t)childNodes.size()});
}
TaffyResult_Unit taffyComputeLayout(WasmPtr taffy, WasmTaffyNode node)
{
    TaffySize_AvailableSpace size;
    size.width.tag = TaffyAvailableSpace_MaxContent;
    size.height.tag = TaffyAvailableSpace_MaxContent;

    return taffy_compute_layout((Taffy*)taffy, {node}, size);
}
TaffyResult_Layout taffyLayout(WasmPtr taffy, WasmTaffyNode node)
{
    return taffy_layout((Taffy*)taffy, {node});
}
TaffyResult_Unit taffyEnableRounding(WasmPtr taffy) { return taffy_enable_rounding((Taffy*)taffy); }
TaffyResult_Unit taffyDisableRounding(WasmPtr taffy)
{
    return taffy_disable_rounding((Taffy*)taffy);
}

EMSCRIPTEN_BINDINGS(RiveTaffy)
{
    function("taffyNew", &taffyNew);
    function("taffyRelease", &taffyRelease);
    function("taffyStyleDefault", &taffy_style_default);
    function("taffySetStyle", &taffySetStyle);
    function("taffyNewLeaf", &taffyNewLeaf);
    function("taffyRemove", &taffyRemove);
    function("taffyMarkDirty", &taffyMarkDirty);
    function("taffySetChildren", &taffySetChildren);
    function("taffyComputeLayout", &taffyComputeLayout);
    function("taffyLayout", &taffyLayout);
    function("taffyEnableRounding", &taffyEnableRounding);
    function("taffyDisableRounding", &taffyDisableRounding);

    value_object<TaffyNodeId>("NodeId").field(
        "pointer",
        optional_override([](const TaffyNodeId& self) -> WasmPtr { return (WasmPtr)self._0; }),
        optional_override([](TaffyNodeId& self, WasmPtr value) { self._0 = (uint64_t)value; }));

    value_object<TaffyError_TaffyChildIndexOutOfBounds_Body>("ErrorData")
        .field("node", &TaffyError_TaffyChildIndexOutOfBounds_Body::parent)
        .field("childIndex", &TaffyError_TaffyChildIndexOutOfBounds_Body::child_index)
        .field("childCount", &TaffyError_TaffyChildIndexOutOfBounds_Body::child_count);

    value_object<TaffyError>("Error")
        .field(
            "tag",
            optional_override([](const TaffyError& self) -> uint8_t { return (uint8_t)self.tag; }),
            optional_override(
                [](TaffyError& self, uint8_t value) { self.tag = (TaffyError_Tag)value; }))
        .field("data", &TaffyError::child_index_out_of_bounds);

    value_object<TaffyResult_Unit>("Result_Unit")
        .field("tag",
               optional_override(
                   [](const TaffyResult_Unit& self) -> uint8_t { return (uint8_t)self.tag; }),
               optional_override([](TaffyResult_Unit& self, uint8_t value) {
                   self.tag = (TaffyResult_Unit_Tag)value;
               }))
        .field("error", &TaffyResult_Unit::err);

    value_object<TaffySize_f32>("Size")
        .field("width", &TaffySize_f32::width)
        .field("height", &TaffySize_f32::height);

    value_object<TaffyPoint_f32>("Point")
        .field("x", &TaffyPoint_f32::x)
        .field("y", &TaffyPoint_f32::y);

    value_object<TaffyLayout>("Layout")
        .field("order", &TaffyLayout::order)
        .field("size", &TaffyLayout::size)
        .field("location", &TaffyLayout::location);

    value_object<TaffyResult_Layout>("Result_Layout")
        .field("tag",
               optional_override(
                   [](const TaffyResult_Layout& self) -> uint8_t { return (uint8_t)self.tag; }),
               optional_override([](TaffyResult_Layout& self, uint8_t value) {
                   self.tag = (TaffyResult_Layout_Tag)value;
               }))
        .field("layout", &TaffyResult_Layout::ok)
        .field("error", &TaffyResult_Layout::err);

    value_object<TaffyResult_NodeId>("Result_NodeId")
        .field("tag",
               optional_override(
                   [](const TaffyResult_NodeId& self) -> uint8_t { return (uint8_t)self.tag; }),
               optional_override([](TaffyResult_NodeId& self, uint8_t value) {
                   self.tag = (TaffyResult_NodeId_Tag)value;
               }))
        .field("node", &TaffyResult_NodeId::ok)
        .field("error", &TaffyResult_NodeId::err);

    value_object<TaffyPoint_Overflow>("Overflow")
        .field("x",
               optional_override([](const TaffyPoint_Overflow& overflow) -> uint8_t {
                   return (uint8_t)overflow.x;
               }),
               optional_override([](TaffyPoint_Overflow& overflow, uint8_t value) {
                   overflow.x = (TaffyOverflow)value;
               }))
        .field("y",
               optional_override([](const TaffyPoint_Overflow& overflow) -> uint8_t {
                   return (uint8_t)overflow.y;
               }),
               optional_override([](TaffyPoint_Overflow& overflow, uint8_t value) {
                   overflow.y = (TaffyOverflow)value;
               }));

    value_object<TaffyLengthPercentageAuto>("LengthPercentageAuto")
        .field("tag",
               optional_override([](const TaffyLengthPercentageAuto& self) -> uint8_t {
                   return (uint8_t)self.tag;
               }),
               optional_override([](TaffyLengthPercentageAuto& self, uint8_t value) {
                   self.tag = (TaffyLengthPercentageAuto_Tag)value;
               }))
        .field("value", &TaffyLengthPercentageAuto::length); // length and percent are the same
    // exposed as value

    value_object<TaffyLengthPercentage>("LengthPercentage")
        .field("tag",
               optional_override(
                   [](const TaffyLengthPercentage& self) -> uint8_t { return (uint8_t)self.tag; }),
               optional_override([](TaffyLengthPercentage& self, uint8_t value) {
                   self.tag = (TaffyLengthPercentage_Tag)value;
               }))
        .field("value", &TaffyLengthPercentage::length); // length and percent are the same
                                                         // exposed as value

    value_object<TaffyDimension>("Dimension")
        .field("tag",
               //    &TaffyDimension::tag,
               optional_override(
                   [](const TaffyDimension& self) -> uint8_t { return (uint8_t)self.tag; }),
               optional_override([](TaffyDimension& self, uint8_t value) {
                   self.tag = (TaffyDimension_Tag)value;
               }))
        .field("value", &TaffyDimension::length);

    value_object<TaffySize_Dimension>("Size_Dimension")
        .field("width", &TaffySize_Dimension::width)
        .field("height", &TaffySize_Dimension::height);

    value_object<TaffyRect_LengthPercentageAuto>("Rect_LengthPercentageAuto")
        .field("left", &TaffyRect_LengthPercentageAuto::left)
        .field("right", &TaffyRect_LengthPercentageAuto::right)
        .field("top", &TaffyRect_LengthPercentageAuto::top)
        .field("bottom", &TaffyRect_LengthPercentageAuto::bottom);

    value_object<TaffyRect_LengthPercentage>("Rect_LengthPercentage")
        .field("left", &TaffyRect_LengthPercentage::left)
        .field("right", &TaffyRect_LengthPercentage::right)
        .field("top", &TaffyRect_LengthPercentage::top)
        .field("bottom", &TaffyRect_LengthPercentage::bottom);

    value_object<TaffyOption_f32>("Option_f32")
        .field("tag",
               //    &TaffyOption_f32::tag,
               optional_override(
                   [](const TaffyOption_f32& self) -> uint8_t { return (uint8_t)self.tag; }),
               optional_override([](TaffyOption_f32& self, uint8_t value) {
                   self.tag = (TaffyOption_f32_Tag)value;
               }))
        .field("value", &TaffyOption_f32::some);

    value_object<TaffySize_LengthPercentage>("Size_LengthPercentage")
        .field("width", &TaffySize_LengthPercentage::width)
        .field("height", &TaffySize_LengthPercentage::height);

    value_object<TaffyStyle>("Style")
        .field("display",
               optional_override(
                   [](const TaffyStyle& style) -> uint8_t { return (uint8_t)style.display; }),
               optional_override(
                   [](TaffyStyle& style, uint8_t value) { style.display = (TaffyDisplay)value; }))
        .field("overflow", &TaffyStyle::overflow)
        .field("scrollbarWidth", &TaffyStyle::scrollbar_width)
        .field("position",
               optional_override(
                   [](const TaffyStyle& style) -> uint8_t { return (uint8_t)style.position; }),
               optional_override(
                   [](TaffyStyle& style, uint8_t value) { style.position = (TaffyPosition)value; }))
        .field("inset", &TaffyStyle::inset)
        .field("size", &TaffyStyle::size)
        .field("minSize", &TaffyStyle::min_size)
        .field("maxSize", &TaffyStyle::max_size)
        .field("aspectRatio", &TaffyStyle::aspect_ratio)
        .field("margin", &TaffyStyle::margin)
        .field("padding", &TaffyStyle::padding)
        .field("border", &TaffyStyle::border)
        .field("alignItems",
               optional_override(
                   [](const TaffyStyle& self) -> uint8_t { return (uint8_t)self.align_items; }),
               optional_override([](TaffyStyle& self, uint8_t value) {
                   self.align_items = (TaffyAlignItems)value;
               }))
        .field("alignSelf",
               optional_override(
                   [](const TaffyStyle& self) -> uint8_t { return (uint8_t)self.align_self; }),
               optional_override([](TaffyStyle& self, uint8_t value) {
                   self.align_self = (TaffyAlignItems)value;
               }))
        .field("justifyItems",
               optional_override(
                   [](const TaffyStyle& self) -> uint8_t { return (uint8_t)self.justify_items; }),
               optional_override([](TaffyStyle& self, uint8_t value) {
                   self.justify_items = (TaffyAlignItems)value;
               }))
        .field("justifySelf",
               optional_override(
                   [](const TaffyStyle& self) -> uint8_t { return (uint8_t)self.justify_self; }),
               optional_override([](TaffyStyle& self, uint8_t value) {
                   self.justify_self = (TaffyAlignSelf)value;
               }))
        .field("alignContent",
               optional_override(
                   [](const TaffyStyle& self) -> uint8_t { return (uint8_t)self.align_content; }),
               optional_override([](TaffyStyle& self, uint8_t value) {
                   self.align_content = (TaffyAlignContent)value;
               }))
        .field("justifyContent",
               optional_override(
                   [](const TaffyStyle& self) -> uint8_t { return (uint8_t)self.justify_content; }),
               optional_override([](TaffyStyle& self, uint8_t value) {
                   self.justify_content = (TaffyJustifyContent)value;
               }))
        .field("gap", &TaffyStyle::gap)
        .field("flexDirection",
               optional_override(
                   [](const TaffyStyle& self) -> uint8_t { return (uint8_t)self.flex_direction; }),
               optional_override([](TaffyStyle& self, uint8_t value) {
                   self.flex_direction = (TaffyFlexDirection)value;
               }))
        .field("flexWrap",
               optional_override(
                   [](const TaffyStyle& self) -> uint8_t { return (uint8_t)self.flex_wrap; }),
               optional_override(
                   [](TaffyStyle& self, uint8_t value) { self.flex_wrap = (TaffyFlexWrap)value; }))
        .field("flexBasis", &TaffyStyle::flex_basis)
        .field("flexGrow", &TaffyStyle::flex_grow)
        .field("flexShrink", &TaffyStyle::flex_shrink);
}