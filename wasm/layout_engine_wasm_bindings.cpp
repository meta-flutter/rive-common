#include <emscripten.h>
#include <emscripten/bind.h>
#include <emscripten/val.h>

#include "yoga/YGNode.h"

#include <stdint.h>
#include <stdio.h>
#include <cstdint>

using namespace emscripten;

using WasmPtr = uint32_t;

WasmPtr makeYogaStyle() { return (WasmPtr) new YGStyle(); }

void disposeYogaStyle(WasmPtr stylePtr)
{
    YGStyle* style = (YGStyle*)stylePtr;
    delete style;
}

int yogaStyleGetAlignContent(WasmPtr stylePtr)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return 0;
    }
    YGAlign align = style->alignContent();
    return (int)align;
}

void yogaStyleSetAlignContent(WasmPtr stylePtr, int align)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->alignContent() = (YGAlign)align;
}

int yogaStyleGetDirection(WasmPtr stylePtr)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return 0;
    }
    YGDirection direction = style->direction();
    return (int)direction;
}

void yogaStyleSetDirection(WasmPtr stylePtr, int direction)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->direction() = (YGDirection)direction;
}

int yogaStyleGetFlexDirection(WasmPtr stylePtr)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return 0;
    }
    YGFlexDirection flexDirection = style->flexDirection();
    return (int)flexDirection;
}

void yogaStyleSetFlexDirection(WasmPtr stylePtr, int flexDirection)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->flexDirection() = (YGFlexDirection)flexDirection;
}

int yogaStyleGetJustifyContent(WasmPtr stylePtr)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return 0;
    }
    YGJustify justify = style->justifyContent();
    return (int)justify;
}

void yogaStyleSetJustifyContent(WasmPtr stylePtr, int justify)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->justifyContent() = (YGJustify)justify;
}

int yogaStyleGetAlignItems(WasmPtr stylePtr)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return 0;
    }
    YGAlign align = style->alignItems();
    return (int)align;
}

void yogaStyleSetAlignItems(WasmPtr stylePtr, int align)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->alignItems() = (YGAlign)align;
}

int yogaStyleGetAlignSelf(WasmPtr stylePtr)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return 0;
    }
    YGAlign align = style->alignSelf();
    return (int)align;
}

void yogaStyleSetAlignSelf(WasmPtr stylePtr, int align)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->alignSelf() = (YGAlign)align;
}

int yogaStyleGetPositionType(WasmPtr stylePtr)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return 0;
    }
    YGPositionType position = style->positionType();
    return (int)position;
}

void yogaStyleSetPositionType(WasmPtr stylePtr, int position)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->positionType() = (YGPositionType)position;
}

int yogaStyleGetFlexWrap(WasmPtr stylePtr)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return 0;
    }
    YGWrap wrap = style->flexWrap();
    return (int)wrap;
}

void yogaStyleSetFlexWrap(WasmPtr stylePtr, int wrap)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->flexWrap() = (YGWrap)wrap;
}

int yogaStyleGetOverflow(WasmPtr stylePtr)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return 0;
    }
    YGOverflow overflow = style->overflow();
    return (int)overflow;
}

void yogaStyleSetOverflow(WasmPtr stylePtr, int overflow)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->overflow() = (YGOverflow)overflow;
}

int yogaStyleGetDisplay(WasmPtr stylePtr)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return 0;
    }
    YGDisplay display = style->display();
    return (int)display;
}

void yogaStyleSetDisplay(WasmPtr stylePtr, int display)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->display() = (YGDisplay)display;
}

float yogaStyleGetFlex(WasmPtr stylePtr)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return 0;
    }
    YGFloatOptional optional = style->flex();
    return optional.unwrap();
}

void yogaStyleSetFlex(WasmPtr stylePtr, float flex)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->flex() = YGFloatOptional(flex);
}

float yogaStyleGetFlexGrow(WasmPtr stylePtr)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return 0;
    }
    YGFloatOptional optional = style->flexGrow();
    return optional.unwrap();
}

void yogaStyleSetFlexGrow(WasmPtr stylePtr, float flex)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->flexGrow() = YGFloatOptional(flex);
}

float yogaStyleGetFlexShrink(WasmPtr stylePtr)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return 0;
    }
    YGFloatOptional optional = style->flexShrink();
    return optional.unwrap();
}

void yogaStyleSetFlexShrink(WasmPtr stylePtr, float flex)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->flexShrink() = YGFloatOptional(flex);
}

YGValue yogaStyleGetFlexBasis(WasmPtr stylePtr)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }
    facebook::yoga::detail::CompactValue compact = style->flexBasis();

    YGValue value = compact;
    return value;
}

void yogaStyleSetFlexBasis(WasmPtr stylePtr, float value, int unit)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->flexBasis() = (YGValue){value, (YGUnit)unit};
}

YGValue yogaStyleGetMargin(WasmPtr stylePtr, int edge)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }

    return style->margin()[(YGEdge)edge];
}

void yogaStyleSetMargin(WasmPtr stylePtr, int edge, float value, int unit)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->margin()[(YGEdge)edge] = (YGValue){value, (YGUnit)unit};
}

YGValue yogaStyleGetPosition(WasmPtr stylePtr, int edge)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }

    return style->position()[(YGEdge)edge];
}

void yogaStyleSetPosition(WasmPtr stylePtr, int edge, float value, int unit)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->position()[(YGEdge)edge] = (YGValue){value, (YGUnit)unit};
}

YGValue yogaStyleGetPadding(WasmPtr stylePtr, int edge)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }

    return style->padding()[(YGEdge)edge];
}

void yogaStyleSetPadding(WasmPtr stylePtr, int edge, float value, int unit)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->padding()[(YGEdge)edge] = (YGValue){value, (YGUnit)unit};
}

YGValue yogaStyleGetBorder(WasmPtr stylePtr, int edge)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }

    return style->border()[(YGEdge)edge];
}

void yogaStyleSetBorder(WasmPtr stylePtr, int edge, float value, int unit)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->border()[(YGEdge)edge] = (YGValue){value, (YGUnit)unit};
}

YGValue yogaStyleGetGap(WasmPtr stylePtr, int gutter)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }

    return style->gap()[(YGGutter)gutter];
}

void yogaStyleSetGap(WasmPtr stylePtr, int gutter, float value, int unit)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->gap()[(YGGutter)gutter] = (YGValue){value, (YGUnit)unit};
}

YGValue yogaStyleGetDimension(WasmPtr stylePtr, int dimension)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }

    return style->dimensions()[(YGDimension)dimension];
}

void yogaStyleSetDimension(WasmPtr stylePtr, int dimension, float value, int unit)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->dimensions()[(YGDimension)dimension] = (YGValue){value, (YGUnit)unit};
}

YGValue yogaStyleGetMinDimension(WasmPtr stylePtr, int dimension)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }

    return style->minDimensions()[(YGDimension)dimension];
}

void yogaStyleSetMinDimension(WasmPtr stylePtr, int dimension, float value, int unit)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->minDimensions()[(YGDimension)dimension] = (YGValue){value, (YGUnit)unit};
}

YGValue yogaStyleGetMaxDimension(WasmPtr stylePtr, int dimension)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }

    return style->maxDimensions()[(YGDimension)dimension];
}

void yogaStyleSetMaxDimension(WasmPtr stylePtr, int dimension, float value, int unit)
{
    YGStyle* style = (YGStyle*)stylePtr;
    if (style == nullptr)
    {
        return;
    }
    style->maxDimensions()[(YGDimension)dimension] = (YGValue){value, (YGUnit)unit};
}

struct NodeContext
{
    emscripten::val jsMeasureFunc;
    emscripten::val jsBaselineFunc;
};

WasmPtr makeYogaNode() { return (WasmPtr) new YGNode(); }

void disposeYogaNode(WasmPtr nodePtr)
{
    YGNode* node = (YGNode*)nodePtr;
    if (node == nullptr)
    {
        return;
    }
    delete (NodeContext*)node->getContext();
    delete node;
}

void yogaNodeCalculateLayout(WasmPtr nodePtr,
                             float availableWidth,
                             float availableHeight,
                             int direction)
{
    YGNode* node = (YGNode*)nodePtr;
    if (node == nullptr)
    {
        return;
    }
    YGNodeCalculateLayout(node, availableWidth, availableHeight, (YGDirection)direction);
}

struct Layout
{
    float left;
    float top;
    float width;
    float height;
};

Layout yogaNodeGetLayout(WasmPtr nodePtr)
{
    YGNode* node = (YGNode*)nodePtr;
    if (node == nullptr)
    {
        return {};
    }
    return {YGNodeLayoutGetLeft(node),
            YGNodeLayoutGetTop(node),
            YGNodeLayoutGetWidth(node),
            YGNodeLayoutGetHeight(node)};
}

static YGSize wasmMeasureFunc(YGNode* node,
                              float width,
                              YGMeasureMode widthMode,
                              float height,
                              YGMeasureMode heightMode)
{
    auto nodeContext = (NodeContext*)node->getContext();
    assert(nodeContext != nullptr);

    emscripten::val result =
        nodeContext->jsMeasureFunc((WasmPtr)node, width, (int)widthMode, height, (int)heightMode);
    return {result[0].as<float>(), result[1].as<float>()};
}

static float wasmBaselineFunc(YGNode* node, float width, float height)
{
    auto nodeContext = (NodeContext*)node->getContext();
    assert(nodeContext != nullptr);

    emscripten::val result = nodeContext->jsBaselineFunc((WasmPtr)node, width, height);
    return result.as<float>();
}

void yogaNodeSetMeasureFunc(WasmPtr nodePtr, emscripten::val jsMeasureFunc)
{
    YGNode* node = (YGNode*)nodePtr;
    if (node == nullptr)
    {
        return;
    }

    auto context = (NodeContext*)node->getContext();
    if (context == nullptr)
    {
        context = new NodeContext();
        node->setContext(context);
    }
    context->jsMeasureFunc = jsMeasureFunc;

    node->setMeasureFunc(wasmMeasureFunc);
}

void yogaNodeClearMeasureFunc(WasmPtr nodePtr)
{
    YGNode* node = (YGNode*)nodePtr;
    if (node == nullptr)
    {
        return;
    }

    node->setMeasureFunc(nullptr);
}

void yogaNodeSetBaselineFunc(WasmPtr nodePtr, emscripten::val jsBaselineFunc)
{
    YGNode* node = (YGNode*)nodePtr;
    if (node == nullptr)
    {
        return;
    }

    auto context = (NodeContext*)node->getContext();
    if (context == nullptr)
    {
        context = new NodeContext();
        node->setContext(context);
    }
    context->jsBaselineFunc = jsBaselineFunc;

    node->setBaselineFunc(wasmBaselineFunc);
}

void yogaNodeClearBaselineFunc(WasmPtr nodePtr)
{
    YGNode* node = (YGNode*)nodePtr;
    if (node == nullptr)
    {
        return;
    }

    node->setBaselineFunc(nullptr);
}

void yogaNodeMarkDirty(WasmPtr nodePtr)
{
    YGNode* node = (YGNode*)nodePtr;
    if (node == nullptr)
    {
        return;
    }

    node->markDirtyAndPropagate();
}

void yogaNodeInsertChild(WasmPtr nodePtr, WasmPtr childPtr, int index)
{
    YGNode* node = (YGNode*)nodePtr;
    YGNode* child = (YGNode*)childPtr;
    if (node == nullptr || child == nullptr)
    {
        return;
    }
    node->insertChild(child, index);
    child->setOwner(node);
    node->markDirtyAndPropagate();
}

void yogaNodeRemoveChild(WasmPtr nodePtr, WasmPtr childPtr)
{
    YGNode* node = (YGNode*)nodePtr;
    YGNode* child = (YGNode*)childPtr;
    if (node == nullptr || child == nullptr)
    {
        return;
    }
    YGNodeRemoveChild(node, child);
}

void yogaNodeClearChildren(WasmPtr nodePtr)
{
    YGNode* node = (YGNode*)nodePtr;
    if (node == nullptr)
    {
        return;
    }
    YGNodeRemoveAllChildren(node);
}

void yogaNodeSetStyle(WasmPtr nodePtr, WasmPtr stylePtr)
{
    YGNode* node = (YGNode*)nodePtr;
    YGStyle* style = (YGStyle*)stylePtr;
    if (node == nullptr || style == nullptr)
    {
        return;
    }
    node->setStyle(*style);
}

int yogaNodeGetType(WasmPtr nodePtr)
{
    YGNode* node = (YGNode*)nodePtr;
    if (node == nullptr)
    {
        return 0;
    }
    return (int)node->getNodeType();
}

void yogaNodeSetType(WasmPtr nodePtr, int type)
{
    YGNode* node = (YGNode*)nodePtr;
    if (node == nullptr)
    {
        return;
    }
    node->setNodeType((YGNodeType)type);
}

EMSCRIPTEN_BINDINGS(LayoutEngine)
{
    value_object<Layout>("Layout")
        .field("left", &Layout::left)
        .field("top", &Layout::top)
        .field("width", &Layout::width)
        .field("height", &Layout::height);

    value_object<YGValue>("YGValue")
        .field("value", &YGValue::value)
        .field("unit",
               optional_override([](const YGValue& self) -> int { return (int)self.unit; }),
               optional_override([](YGValue& self, int value) { self.unit = (YGUnit)value; }));

    function("makeYogaStyle", &makeYogaStyle);
    function("disposeYogaStyle", &disposeYogaStyle);

    function("yogaStyleGetAlignContent", &yogaStyleGetAlignContent);
    function("yogaStyleSetAlignContent", &yogaStyleSetAlignContent);
    function("yogaStyleGetDirection", &yogaStyleGetDirection);
    function("yogaStyleSetDirection", &yogaStyleSetDirection);
    function("yogaStyleGetFlexDirection", &yogaStyleGetFlexDirection);
    function("yogaStyleSetFlexDirection", &yogaStyleSetFlexDirection);
    function("yogaStyleGetJustifyContent", &yogaStyleGetJustifyContent);
    function("yogaStyleSetJustifyContent", &yogaStyleSetJustifyContent);
    function("yogaStyleGetAlignItems", &yogaStyleGetAlignItems);
    function("yogaStyleSetAlignItems", &yogaStyleSetAlignItems);
    function("yogaStyleGetAlignSelf", &yogaStyleGetAlignSelf);
    function("yogaStyleSetAlignSelf", &yogaStyleSetAlignSelf);
    function("yogaStyleGetPositionType", &yogaStyleGetPositionType);
    function("yogaStyleSetPositionType", &yogaStyleSetPositionType);
    function("yogaStyleGetFlexWrap", &yogaStyleGetFlexWrap);
    function("yogaStyleSetFlexWrap", &yogaStyleSetFlexWrap);
    function("yogaStyleGetOverflow", &yogaStyleGetOverflow);
    function("yogaStyleSetOverflow", &yogaStyleSetOverflow);
    function("yogaStyleGetDisplay", &yogaStyleGetDisplay);
    function("yogaStyleSetDisplay", &yogaStyleSetDisplay);
    function("yogaStyleGetFlex", &yogaStyleGetFlex);
    function("yogaStyleSetFlex", &yogaStyleSetFlex);
    function("yogaStyleGetFlexGrow", &yogaStyleGetFlexGrow);
    function("yogaStyleSetFlexGrow", &yogaStyleSetFlexGrow);
    function("yogaStyleGetFlexShrink", &yogaStyleGetFlexShrink);
    function("yogaStyleSetFlexShrink", &yogaStyleSetFlexShrink);
    function("yogaStyleGetFlexBasis", &yogaStyleGetFlexBasis);
    function("yogaStyleSetFlexBasis", &yogaStyleSetFlexBasis);
    function("yogaStyleGetMargin", &yogaStyleGetMargin);
    function("yogaStyleSetMargin", &yogaStyleSetMargin);
    function("yogaStyleGetPosition", &yogaStyleGetPosition);
    function("yogaStyleSetPosition", &yogaStyleSetPosition);
    function("yogaStyleGetPadding", &yogaStyleGetPadding);
    function("yogaStyleSetPadding", &yogaStyleSetPadding);
    function("yogaStyleGetBorder", &yogaStyleGetBorder);
    function("yogaStyleSetBorder", &yogaStyleSetBorder);
    function("yogaStyleGetGap", &yogaStyleGetGap);
    function("yogaStyleSetGap", &yogaStyleSetGap);
    function("yogaStyleGetDimension", &yogaStyleGetDimension);
    function("yogaStyleSetDimension", &yogaStyleSetDimension);
    function("yogaStyleGetMinDimension", &yogaStyleGetMinDimension);
    function("yogaStyleSetMinDimension", &yogaStyleSetMinDimension);
    function("yogaStyleGetMaxDimension", &yogaStyleGetMaxDimension);
    function("yogaStyleSetMaxDimension", &yogaStyleSetMaxDimension);

    function("makeYogaNode", &makeYogaNode);
    function("disposeYogaNode", &disposeYogaNode);
    function("yogaNodeCalculateLayout", &yogaNodeCalculateLayout);
    function("yogaNodeGetLayout", &yogaNodeGetLayout);
    function("yogaNodeSetMeasureFunc", &yogaNodeSetMeasureFunc);
    function("yogaNodeClearMeasureFunc", &yogaNodeClearMeasureFunc);
    function("yogaNodeSetBaselineFunc", &yogaNodeSetBaselineFunc);
    function("yogaNodeClearBaselineFunc", &yogaNodeClearBaselineFunc);
    function("yogaNodeMarkDirty", &yogaNodeMarkDirty);
    function("yogaNodeInsertChild", &yogaNodeInsertChild);
    function("yogaNodeClearChildren", &yogaNodeClearChildren);
    function("yogaNodeSetStyle", &yogaNodeSetStyle);
    function("yogaNodeGetType", &yogaNodeGetType);
    function("yogaNodeSetType", &yogaNodeSetType);
    function("yogaNodeRemoveChild", &yogaNodeRemoveChild);
}