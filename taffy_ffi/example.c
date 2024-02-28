#include <stdio.h>

#include "src/taffy.h"

int error(TaffyError error) { return -1; }

int main(void)
{
    Taffy* taffy = taffy_new();

    TaffyNodeId header_node;
    TaffyNodeId body_node;
    TaffyNodeId root_node;

    TaffyStyle style = taffy_style_default();
    style.size.width.tag = TaffyDimension_Length;
    style.size.width.length = 800;
    style.size.height.tag = TaffyDimension_Length;
    style.size.height.length = 100;

    TaffyResult_NodeId result = taffy_new_leaf(taffy, style);
    if (result.tag == TaffyResult_NodeId_Ok_NodeId)
    {
        header_node = result.ok;
    }
    else
    {
        return error(result.err);
    }

    style = taffy_style_default();
    style.size.width.tag = TaffyDimension_Length;
    style.size.width.length = 800;
    style.size.height.tag = TaffyDimension_Auto;
    style.flex_grow = 1;

    result = taffy_new_leaf(taffy, style);
    if (result.tag == TaffyResult_NodeId_Ok_NodeId)
    {
        body_node = result.ok;
    }
    else
    {
        return error(result.err);
    }

    style = taffy_style_default();
    style.flex_direction = TaffyFlexDirection_Column;
    style.size.width.length = 800;
    style.size.height.tag = TaffyDimension_Length;
    style.size.height.length = 600;

    TaffyNodeId children[] = {header_node, body_node};
    TaffySlice_NodeId children_slice;
    children_slice.data = children;
    children_slice.len = 2;

    result = taffy_new_with_children(taffy, style, children_slice);
    if (result.tag == TaffyResult_NodeId_Ok_NodeId)
    {
        root_node = result.ok;
    }
    else
    {
        return error(result.err);
    }

    TaffySize_AvailableSpace size;
    size.width.tag = TaffyAvailableSpace_MaxContent;
    size.height.tag = TaffyAvailableSpace_MaxContent;

    TaffyResult_Unit result_unit = taffy_compute_layout(taffy, root_node, size);
    if (result_unit.tag == TaffyResult_NodeId_Err_NodeId)
    {
        return error(result.err);
    }

    printf("%.1f\n", taffy_layout(taffy, root_node).ok.size.width);
    printf("%.1f\n", taffy_layout(taffy, root_node).ok.size.height);
    printf("%.1f\n", taffy_layout(taffy, header_node).ok.size.width);
    printf("%.1f\n", taffy_layout(taffy, header_node).ok.size.height);
    printf("%.1f\n", taffy_layout(taffy, body_node).ok.size.width);
    printf("%.1f\n", taffy_layout(taffy, body_node).ok.size.height);

    taffy_release(taffy);

    return 0;
}
