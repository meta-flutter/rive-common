#include "yoga/YGNode.h"

#include <stdio.h>
#include <cstdint>

#if defined(_MSC_VER)
#define EXPORT extern "C" __declspec(dllexport)
#else
#define EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))
#endif

EXPORT YGStyle* makeYogaStyle() { return new YGStyle(); }

EXPORT void disposeYogaStyle(YGStyle* style) { delete style; }

EXPORT int yogaStyleGetAlignContent(YGStyle* style)
{
    if (style == nullptr)
    {
        return 0;
    }
    YGAlign align = style->alignContent();
    return (int)align;
}

EXPORT void yogaStyleSetAlignContent(YGStyle* style, int align)
{
    if (style == nullptr)
    {
        return;
    }
    style->alignContent() = (YGAlign)align;
}

EXPORT int yogaStyleGetDirection(YGStyle* style)
{
    if (style == nullptr)
    {
        return 0;
    }
    YGDirection direction = style->direction();
    return (int)direction;
}

EXPORT void yogaStyleSetDirection(YGStyle* style, int direction)
{
    if (style == nullptr)
    {
        return;
    }
    style->direction() = (YGDirection)direction;
}

EXPORT int yogaStyleGetFlexDirection(YGStyle* style)
{
    if (style == nullptr)
    {
        return 0;
    }
    YGFlexDirection flexDirection = style->flexDirection();
    return (int)flexDirection;
}

EXPORT void yogaStyleSetFlexDirection(YGStyle* style, int flexDirection)
{
    if (style == nullptr)
    {
        return;
    }
    style->flexDirection() = (YGFlexDirection)flexDirection;
}

EXPORT int yogaStyleGetJustifyContent(YGStyle* style)
{
    if (style == nullptr)
    {
        return 0;
    }
    YGJustify justify = style->justifyContent();
    return (int)justify;
}

EXPORT void yogaStyleSetJustifyContent(YGStyle* style, int justify)
{
    if (style == nullptr)
    {
        return;
    }
    style->justifyContent() = (YGJustify)justify;
}

EXPORT int yogaStyleGetAlignItems(YGStyle* style)
{
    if (style == nullptr)
    {
        return 0;
    }
    YGAlign align = style->alignItems();
    return (int)align;
}

EXPORT void yogaStyleSetAlignItems(YGStyle* style, int align)
{
    if (style == nullptr)
    {
        return;
    }
    style->alignItems() = (YGAlign)align;
}

EXPORT int yogaStyleGetAlignSelf(YGStyle* style)
{
    if (style == nullptr)
    {
        return 0;
    }
    YGAlign align = style->alignSelf();
    return (int)align;
}

EXPORT void yogaStyleSetAlignSelf(YGStyle* style, int align)
{
    if (style == nullptr)
    {
        return;
    }
    style->alignSelf() = (YGAlign)align;
}

EXPORT int yogaStyleGetPositionType(YGStyle* style)
{
    if (style == nullptr)
    {
        return 0;
    }
    YGPositionType position = style->positionType();
    return (int)position;
}

EXPORT void yogaStyleSetPositionType(YGStyle* style, int position)
{
    if (style == nullptr)
    {
        return;
    }
    style->positionType() = (YGPositionType)position;
}

EXPORT int yogaStyleGetFlexWrap(YGStyle* style)
{
    if (style == nullptr)
    {
        return 0;
    }
    YGWrap wrap = style->flexWrap();
    return (int)wrap;
}

EXPORT void yogaStyleSetFlexWrap(YGStyle* style, int wrap)
{
    if (style == nullptr)
    {
        return;
    }
    style->flexWrap() = (YGWrap)wrap;
}

EXPORT int yogaStyleGetOverflow(YGStyle* style)
{
    if (style == nullptr)
    {
        return 0;
    }
    YGOverflow overflow = style->overflow();
    return (int)overflow;
}

EXPORT void yogaStyleSetOverflow(YGStyle* style, int overflow)
{
    if (style == nullptr)
    {
        return;
    }
    style->overflow() = (YGOverflow)overflow;
}

EXPORT int yogaStyleGetDisplay(YGStyle* style)
{
    if (style == nullptr)
    {
        return 0;
    }
    YGDisplay display = style->display();
    return (int)display;
}

EXPORT void yogaStyleSetDisplay(YGStyle* style, int display)
{
    if (style == nullptr)
    {
        return;
    }
    style->display() = (YGDisplay)display;
}

EXPORT float yogaStyleGetFlex(YGStyle* style)
{
    if (style == nullptr)
    {
        return 0;
    }
    YGFloatOptional optional = style->flex();
    return optional.unwrap();
}

EXPORT void yogaStyleSetFlex(YGStyle* style, float flex)
{
    if (style == nullptr)
    {
        return;
    }
    style->flex() = YGFloatOptional(flex);
}

EXPORT float yogaStyleGetFlexGrow(YGStyle* style)
{
    if (style == nullptr)
    {
        return 0;
    }
    YGFloatOptional optional = style->flexGrow();
    return optional.unwrap();
}

EXPORT void yogaStyleSetFlexGrow(YGStyle* style, float flex)
{
    if (style == nullptr)
    {
        return;
    }
    style->flexGrow() = YGFloatOptional(flex);
}

EXPORT float yogaStyleGetFlexShrink(YGStyle* style)
{
    if (style == nullptr)
    {
        return 0;
    }
    YGFloatOptional optional = style->flexShrink();
    return optional.unwrap();
}

EXPORT void yogaStyleSetFlexShrink(YGStyle* style, float flex)
{
    if (style == nullptr)
    {
        return;
    }
    style->flexShrink() = YGFloatOptional(flex);
}

EXPORT YGValue yogaStyleGetFlexBasis(YGStyle* style)
{
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }
    facebook::yoga::detail::CompactValue compact = style->flexBasis();

    YGValue value = compact;
    return value;
}

EXPORT void yogaStyleSetFlexBasis(YGStyle* style, float value, int unit)
{
    if (style == nullptr)
    {
        return;
    }
    style->flexBasis() = (YGValue){value, (YGUnit)unit};
}

EXPORT YGValue yogaStyleGetMargin(YGStyle* style, int edge)
{
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }

    return style->margin()[(YGEdge)edge];
}

EXPORT void yogaStyleSetMargin(YGStyle* style, int edge, float value, int unit)
{
    if (style == nullptr)
    {
        return;
    }
    style->margin()[(YGEdge)edge] = (YGValue){value, (YGUnit)unit};
}

EXPORT YGValue yogaStyleGetPosition(YGStyle* style, int edge)
{
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }

    return style->position()[(YGEdge)edge];
}

EXPORT void yogaStyleSetPosition(YGStyle* style, int edge, float value, int unit)
{
    if (style == nullptr)
    {
        return;
    }
    style->position()[(YGEdge)edge] = (YGValue){value, (YGUnit)unit};
}

EXPORT YGValue yogaStyleGetPadding(YGStyle* style, int edge)
{
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }

    return style->padding()[(YGEdge)edge];
}

EXPORT void yogaStyleSetPadding(YGStyle* style, int edge, float value, int unit)
{
    if (style == nullptr)
    {
        return;
    }
    style->padding()[(YGEdge)edge] = (YGValue){value, (YGUnit)unit};
}

EXPORT YGValue yogaStyleGetBorder(YGStyle* style, int edge)
{
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }

    return style->border()[(YGEdge)edge];
}

EXPORT void yogaStyleSetBorder(YGStyle* style, int edge, float value, int unit)
{
    if (style == nullptr)
    {
        return;
    }
    style->border()[(YGEdge)edge] = (YGValue){value, (YGUnit)unit};
}

EXPORT YGValue yogaStyleGetGap(YGStyle* style, int gutter)
{
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }

    return style->gap()[(YGGutter)gutter];
}

EXPORT void yogaStyleSetGap(YGStyle* style, int gutter, float value, int unit)
{
    if (style == nullptr)
    {
        return;
    }
    style->gap()[(YGGutter)gutter] = (YGValue){value, (YGUnit)unit};
}

EXPORT YGValue yogaStyleGetDimension(YGStyle* style, int dimension)
{
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }

    return style->dimensions()[(YGDimension)dimension];
}

EXPORT void yogaStyleSetDimension(YGStyle* style, int dimension, float value, int unit)
{
    if (style == nullptr)
    {
        return;
    }
    style->dimensions()[(YGDimension)dimension] = (YGValue){value, (YGUnit)unit};
}

EXPORT YGValue yogaStyleGetMinDimension(YGStyle* style, int dimension)
{
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }

    return style->minDimensions()[(YGDimension)dimension];
}

EXPORT void yogaStyleSetMinDimension(YGStyle* style, int dimension, float value, int unit)
{
    if (style == nullptr)
    {
        return;
    }
    style->minDimensions()[(YGDimension)dimension] = (YGValue){value, (YGUnit)unit};
}

EXPORT YGValue yogaStyleGetMaxDimension(YGStyle* style, int dimension)
{
    if (style == nullptr)
    {
        return {0.0f, YGUnitAuto};
    }

    return style->maxDimensions()[(YGDimension)dimension];
}

EXPORT void yogaStyleSetMaxDimension(YGStyle* style, int dimension, float value, int unit)
{
    if (style == nullptr)
    {
        return;
    }
    style->maxDimensions()[(YGDimension)dimension] = (YGValue){value, (YGUnit)unit};
}

EXPORT YGNode* makeYogaNode()
{
    auto node = new YGNode();
    // Default to use fractional pixel values
    node->getConfig()->setPointScaleFactor(0);
    return node;
}

EXPORT void disposeYogaNode(YGNode* node) { delete node; }

EXPORT void yogaNodeSetStyle(YGNode* node, YGStyle* style)
{
    if (node == nullptr)
    {
        return;
    }
    node->setStyle(*style);
}

EXPORT int yogaNodeGetType(YGNode* node)
{
    if (node == nullptr)
    {
        return 0;
    }
    return (int)node->getNodeType();
}

EXPORT void yogaNodeSetType(YGNode* node, int type)
{
    if (node == nullptr)
    {
        return;
    }
    node->setNodeType((YGNodeType)type);
}

EXPORT void yogaNodeInsertChild(YGNode* node, YGNode* child, int index)
{
    if (node == nullptr || child == nullptr)
    {
        return;
    }
    node->insertChild(child, index);
    child->setOwner(node);
    node->markDirtyAndPropagate();
}

EXPORT void yogaNodeRemoveChild(YGNode* node, YGNode* child)
{
    if (node == nullptr || child == nullptr)
    {
        return;
    }
    YGNodeRemoveChild(node, child);
}

EXPORT void yogaNodeClearChildren(YGNode* node)
{
    if (node == nullptr)
    {
        return;
    }
    YGNodeRemoveAllChildren(node);
}

EXPORT void yogaNodeCalculateLayout(YGNode* node,
                                    float availableWidth,
                                    float availableHeight,
                                    int direction)
{
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

EXPORT Layout yogaNodeGetLayout(YGNode* node)
{
    if (node == nullptr)
    {
        return {};
    }

    return {YGNodeLayoutGetLeft(node),
            YGNodeLayoutGetTop(node),
            YGNodeLayoutGetWidth(node),
            YGNodeLayoutGetHeight(node)};
}

EXPORT void yogaNodeSetMeasureFunc(YGNode* node, YGMeasureFunc measureFunc)
{
    if (node == nullptr)
    {
        return;
    }

    node->setMeasureFunc(measureFunc);
}

EXPORT void yogaNodeClearMeasureFunc(YGNode* node)
{
    if (node == nullptr)
    {
        return;
    }

    node->setMeasureFunc(nullptr);
}

EXPORT void yogaNodeSetBaselineFunc(YGNode* node, YGBaselineFunc baselineFunc)
{
    if (node == nullptr)
    {
        return;
    }

    node->setBaselineFunc(baselineFunc);
}

EXPORT void yogaNodeClearBaselineFunc(YGNode* node)
{
    if (node == nullptr)
    {
        return;
    }

    node->setBaselineFunc(nullptr);
}

EXPORT void yogaNodeMarkDirty(YGNode* node)
{
    if (node == nullptr)
    {
        return;
    }

    node->markDirtyAndPropagate();
}