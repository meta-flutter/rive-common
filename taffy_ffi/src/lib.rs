#![no_std]

extern crate alloc;

use alloc::boxed::Box;
use core::{ffi::c_void, ptr::NonNull, slice};

use types::{
    geometry::Size,
    layout::Layout,
    style::{AvailableSpace, Style},
    NodeId, Slice, Unit,
};

mod types;

macro_rules! get_or_return_error {
    ( $val:expr ) => {
        match $val {
            Some(val) => val,
            None => return types::Result::Err(types::Error::NullPointer),
        }
    };
}

macro_rules! get_taffy_or_return_error {
    ( $ptr:expr ) => {
        match $ptr.map(|ptr| ptr.cast::<taffy::Taffy::<NonNull<c_void>>>().as_mut()) {
            Some(val) => val,
            None => return types::Result::Err(types::Error::NullPointer),
        }
    };
}

#[no_mangle]
pub unsafe extern "C" fn taffy_new() -> Option<NonNull<types::Taffy>> {
    NonNull::new(Box::into_raw(Box::new(taffy::Taffy::<NonNull<c_void>>::new())).cast())
}

#[no_mangle]
pub unsafe extern "C" fn taffy_with_capacity(capacity: usize) -> Option<NonNull<types::Taffy>> {
    NonNull::new(Box::into_raw(Box::new(taffy::Taffy::<NonNull<c_void>>::with_capacity(capacity))).cast())
}

#[no_mangle]
pub unsafe extern "C" fn taffy_release(taffy: Option<NonNull<types::Taffy>>) {
    taffy
        .map(|ptr| Box::from_raw(ptr.as_ptr().cast::<taffy::Taffy::<NonNull<c_void>>>()))
        .unwrap();
}

#[no_mangle]
pub unsafe extern "C" fn taffy_style_default() -> Style {
    Style::default()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_enable_rounding(
    taffy: Option<NonNull<types::Taffy>>,
) -> types::Result<Unit> {
    get_taffy_or_return_error!(taffy).enable_rounding();

    Ok(()).into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_disable_rounding(
    taffy: Option<NonNull<types::Taffy>>,
) -> types::Result<Unit> {
    get_taffy_or_return_error!(taffy).disable_rounding();

    Ok(()).into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_new_leaf(
    taffy: Option<NonNull<types::Taffy>>,
    layout: Style,
) -> types::Result<NodeId> {
    get_taffy_or_return_error!(taffy)
        .new_leaf(get_or_return_error!(layout.try_into().ok()))
        .into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_new_leaf_with_context(
    taffy: Option<NonNull<types::Taffy>>,
    layout: Style,
    context: NonNull<c_void>,
) -> types::Result<NodeId> {
    get_taffy_or_return_error!(taffy)
        .new_leaf_with_context(get_or_return_error!(layout.try_into().ok()), context)
        .into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_new_with_children(
    taffy: Option<NonNull<types::Taffy>>,
    layout: Style,
    children: Slice<NodeId>,
) -> types::Result<NodeId> {
    get_taffy_or_return_error!(taffy)
        .new_with_children(
            get_or_return_error!(layout.try_into().ok()),
            get_or_return_error!(children.try_into().ok()),
        )
        .into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_clear(taffy: Option<NonNull<types::Taffy>>) -> types::Result<Unit> {
    get_taffy_or_return_error!(taffy).clear();

    Ok(()).into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_remove(
    taffy: Option<NonNull<types::Taffy>>,
    node: NodeId,
) -> types::Result<NodeId> {
    get_taffy_or_return_error!(taffy).remove(node.into()).into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_set_node_context(
    taffy: Option<NonNull<types::Taffy>>,
    node: NodeId,
    context: Option<NonNull<c_void>>,
) -> types::Result<Unit> {
    get_taffy_or_return_error!(taffy)
        .set_node_context(node.into(), context)
        .into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_add_child(
    taffy: Option<NonNull<types::Taffy>>,
    parent: NodeId,
    child: NodeId,
) -> types::Result<Unit> {
    get_taffy_or_return_error!(taffy)
        .add_child(parent.into(), child.into())
        .into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_set_children(
    taffy: Option<NonNull<types::Taffy>>,
    parent: NodeId,
    children: Slice<NodeId>,
) -> types::Result<Unit> {
    get_taffy_or_return_error!(taffy)
        .set_children(
            parent.into(),
            get_or_return_error!(children.try_into().ok()),
        )
        .into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_remove_child(
    taffy: Option<NonNull<types::Taffy>>,
    parent: NodeId,
    child: NodeId,
) -> types::Result<NodeId> {
    get_taffy_or_return_error!(taffy)
        .remove_child(parent.into(), child.into())
        .into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_remove_child_at_index(
    taffy: Option<NonNull<types::Taffy>>,
    parent: NodeId,
    child_index: usize,
) -> types::Result<NodeId> {
    get_taffy_or_return_error!(taffy)
        .remove_child_at_index(parent.into(), child_index)
        .into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_replace_child_at_index(
    taffy: Option<NonNull<types::Taffy>>,
    parent: NodeId,
    child_index: usize,
    new_child: NodeId,
) -> types::Result<NodeId> {
    get_taffy_or_return_error!(taffy)
        .replace_child_at_index(parent.into(), child_index, new_child.into())
        .into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_child_at_index(
    taffy: Option<NonNull<types::Taffy>>,
    parent: NodeId,
    child_index: usize,
) -> types::Result<NodeId> {
    get_taffy_or_return_error!(taffy)
        .child_at_index(parent.into(), child_index)
        .into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_child_count(
    taffy: Option<NonNull<types::Taffy>>,
    parent: NodeId,
) -> types::Result<usize> {
    get_taffy_or_return_error!(taffy)
        .child_count(parent.into())
        .into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_children(
    taffy: Option<NonNull<types::Taffy>>,
    parent: NodeId,
    children_buffer: Option<NonNull<NodeId>>,
) -> types::Result<Unit> {
    match get_taffy_or_return_error!(taffy).children(parent.into()) {
        Ok(children) => {
            slice::from_raw_parts_mut(
                get_or_return_error!(children_buffer).cast().as_ptr(),
                children.len(),
            )
            .copy_from_slice(&children);

            Ok(()).into()
        }
        Err(e) => taffy::tree::TaffyResult::<()>::Err(e).into(),
    }
}

#[no_mangle]
pub unsafe extern "C" fn taffy_set_style(
    taffy: Option<NonNull<types::Taffy>>,
    node: NodeId,
    style: Style,
) -> types::Result<Unit> {
    get_taffy_or_return_error!(taffy)
        .set_style(node.into(), get_or_return_error!(style.try_into().ok()))
        .into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_layout(
    taffy: Option<NonNull<types::Taffy>>,
    node: NodeId,
) -> types::Result<Layout> {
    get_taffy_or_return_error!(taffy)
        .layout(node.into())
        .copied()
        .into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_mark_dirty(
    taffy: Option<NonNull<types::Taffy>>,
    node: NodeId,
) -> types::Result<Unit> {
    get_taffy_or_return_error!(taffy)
        .mark_dirty(node.into())
        .into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_compute_layout(
    taffy: Option<NonNull<types::Taffy>>,
    node: NodeId,
    available_space: Size<AvailableSpace>,
) -> types::Result<Unit> {
    get_taffy_or_return_error!(taffy)
        .compute_layout(node.into(), available_space.into())
        .into()
}

#[no_mangle]
pub unsafe extern "C" fn taffy_compute_layout_with_measure(
    taffy: Option<NonNull<types::Taffy>>,
    node: NodeId,
    available_space: Size<AvailableSpace>,
    measure_function: extern "C" fn(
        Size<types::Option<f32>>,
        Size<AvailableSpace>,
        NodeId,
        Option<NonNull<c_void>>,
    ) -> Size<f32>,
) -> types::Result<Unit> {
    get_taffy_or_return_error!(taffy)
        .compute_layout_with_measure(
            node.into(),
            available_space.into(),
            |known_dimensions, available_space, node_id, node_context| {
                measure_function(
                    Size {
                        width: types::Option::from(known_dimensions.width),
                        height: types::Option::from(known_dimensions.height),
                    },
                    available_space.into(),
                    node_id.into(),
                    node_context.copied(),
                )
                .into()
            },
        )
        .into()
}

#[cfg(test)]
mod tests {
    use super::*;

    use alloc::vec::Vec;

    use types::style::*;

    #[test]
    fn new_release() {
        unsafe {
            let taffy = taffy_new();
            taffy_release(taffy);
        }
    }

    #[test]
    fn new_auto() {
        unsafe {
            let taffy = taffy_new();

            let child = taffy_new_leaf(
                taffy,
                Style {
                    size: Size {
                        width: Dimension::Auto,
                        height: Dimension::Auto,
                    },
                    flex_grow: 1.0,
                    ..Default::default()
                },
            )
            .unwrap();
            let root = taffy_new_with_children(
                taffy,
                Style {
                    size: Size {
                        width: Dimension::Length(100.0),
                        height: Dimension::Length(100.0),
                    },
                    ..Default::default()
                },
                Slice::new(&mut [child]),
            )
            .unwrap();

            taffy_compute_layout(
                taffy,
                root,
                Size {
                    width: AvailableSpace::MaxContent,
                    height: AvailableSpace::MaxContent,
                },
            )
            .unwrap();

            let layout = taffy_layout(taffy, child).unwrap();

            assert_eq!(layout.size.width, 100.0);
            assert_eq!(layout.size.height, 100.0);

            taffy_release(taffy);
        }
    }

    #[test]
    fn rounding() {
        unsafe {
            let taffy = taffy_new();

            taffy_disable_rounding(taffy);

            let child = taffy_new_leaf(
                taffy,
                Style {
                    size: Size {
                        width: Dimension::Auto,
                        height: Dimension::Auto,
                    },
                    flex_grow: 1.0,
                    ..Default::default()
                },
            )
            .unwrap();
            let root = taffy_new_with_children(
                taffy,
                Style {
                    size: Size {
                        width: Dimension::Length(100.5),
                        height: Dimension::Length(100.5),
                    },
                    ..Default::default()
                },
                Slice::new(&mut [child]),
            )
            .unwrap();

            taffy_compute_layout(
                taffy,
                root,
                Size {
                    width: AvailableSpace::MaxContent,
                    height: AvailableSpace::MaxContent,
                },
            )
            .unwrap();

            let layout = taffy_layout(taffy, child).unwrap();

            assert_eq!(layout.size.width, 100.5);
            assert_eq!(layout.size.height, 100.5);

            taffy_enable_rounding(taffy);

            let child = taffy_new_leaf(
                taffy,
                Style {
                    size: Size {
                        width: Dimension::Auto,
                        height: Dimension::Auto,
                    },
                    flex_grow: 1.0,
                    ..Default::default()
                },
            )
            .unwrap();
            let root = taffy_new_with_children(
                taffy,
                Style {
                    size: Size {
                        width: Dimension::Length(100.5),
                        height: Dimension::Length(100.5),
                    },
                    ..Default::default()
                },
                Slice::new(&mut [child]),
            )
            .unwrap();

            taffy_compute_layout(
                taffy,
                root,
                Size {
                    width: AvailableSpace::MaxContent,
                    height: AvailableSpace::MaxContent,
                },
            )
            .unwrap();

            let layout = taffy_layout(taffy, child).unwrap();

            assert_eq!(layout.size.width, 101.0);
            assert_eq!(layout.size.height, 101.0);

            taffy_release(taffy);
        }
    }

    #[test]
    fn changing_measure() {
        unsafe {
            let mut half = false;
            let half_ptr = &mut half as *mut bool;

            extern "C" fn measure_function(
                _: Size<types::Option<f32>>,
                _: Size<AvailableSpace>,
                _: NodeId,
                half: Option<NonNull<c_void>>,
            ) -> Size<f32> {
                if unsafe { *half.unwrap().cast().as_ref() } {
                    Size {
                        width: 50.0,
                        height: 50.0,
                    }
                } else {
                    Size {
                        width: 100.0,
                        height: 100.0,
                    }
                }
            }

            let taffy = taffy_new();

            let child = taffy_new_leaf_with_context(
                taffy,
                Style {
                    ..Default::default()
                },
                NonNull::new(half_ptr).unwrap().cast(),
            )
            .unwrap();
            let root = taffy_new_with_children(
                taffy,
                Style {
                    size: Size {
                        width: Dimension::Length(100.0),
                        height: Dimension::Length(100.0),
                    },
                    ..Default::default()
                },
                Slice::new(&mut [child]),
            )
            .unwrap();

            taffy_compute_layout_with_measure(
                taffy,
                root,
                Size {
                    width: AvailableSpace::MinContent,
                    height: AvailableSpace::MinContent,
                },
                measure_function,
            )
            .unwrap();

            let layout = taffy_layout(taffy, child).unwrap();

            assert_eq!(layout.size.width, 100.0);
            assert_eq!(layout.size.height, 100.0);

            *half_ptr = true;

            taffy_compute_layout_with_measure(
                taffy,
                root,
                Size {
                    width: AvailableSpace::MinContent,
                    height: AvailableSpace::MinContent,
                },
                measure_function,
            )
            .unwrap();

            let layout = taffy_layout(taffy, child).unwrap();

            assert_eq!(layout.size.width, 100.0);
            assert_eq!(layout.size.height, 100.0);

            taffy_release(taffy);
        }
    }

    #[test]
    #[should_panic]
    fn clear() {
        unsafe {
            let taffy = taffy_new();

            let root = taffy_new_leaf(taffy, Style::default()).unwrap();

            taffy_clear(taffy);

            taffy_child_count(taffy, root);
        }
    }

    #[test]
    fn remove() {
        unsafe {
            let taffy = taffy_new();

            let root = taffy_new_leaf(taffy, Style::default()).unwrap();

            assert_eq!(taffy_remove(taffy, root).unwrap(), root);
        }
    }

    #[test]
    fn set_changing_measure() {
        unsafe {
            let mut half = false;
            let half_ptr = &mut half as *mut bool;

            extern "C" fn measure_function(
                _: Size<types::Option<f32>>,
                _: Size<AvailableSpace>,
                _: NodeId,
                half: Option<NonNull<c_void>>,
            ) -> Size<f32> {
                if unsafe { *half.unwrap().cast().as_ref() } {
                    Size {
                        width: 50.0,
                        height: 50.0,
                    }
                } else {
                    Size {
                        width: 100.0,
                        height: 100.0,
                    }
                }
            }

            let taffy = taffy_new();

            let child = taffy_new_leaf(
                taffy,
                Style {
                    ..Default::default()
                },
            )
            .unwrap();
            taffy_set_node_context(taffy, child, NonNull::new(half_ptr).map(|ptr| ptr.cast()));
            let root = taffy_new_with_children(
                taffy,
                Style {
                    size: Size {
                        width: Dimension::Length(100.0),
                        height: Dimension::Length(100.0),
                    },
                    ..Default::default()
                },
                Slice::new(&mut [child]),
            )
            .unwrap();

            taffy_compute_layout_with_measure(
                taffy,
                root,
                Size {
                    width: AvailableSpace::MinContent,
                    height: AvailableSpace::MinContent,
                },
                measure_function,
            )
            .unwrap();

            let layout = taffy_layout(taffy, child).unwrap();

            assert_eq!(layout.size.width, 100.0);
            assert_eq!(layout.size.height, 100.0);

            *half_ptr = true;

            taffy_compute_layout_with_measure(
                taffy,
                root,
                Size {
                    width: AvailableSpace::MinContent,
                    height: AvailableSpace::MinContent,
                },
                measure_function,
            )
            .unwrap();

            let layout = taffy_layout(taffy, child).unwrap();

            assert_eq!(layout.size.width, 100.0);
            assert_eq!(layout.size.height, 100.0);

            taffy_release(taffy);
        }
    }

    #[test]
    fn add_child() {
        unsafe {
            let taffy = taffy_new();

            let child = taffy_new_leaf(
                taffy,
                Style {
                    size: Size {
                        width: Dimension::Auto,
                        height: Dimension::Auto,
                    },
                    flex_grow: 1.0,
                    ..Default::default()
                },
            )
            .unwrap();

            let root = taffy_new_leaf(
                taffy,
                Style {
                    size: Size {
                        width: Dimension::Length(100.0),
                        height: Dimension::Length(100.0),
                    },
                    ..Default::default()
                },
            )
            .unwrap();
            taffy_add_child(taffy, root, child);

            taffy_compute_layout(
                taffy,
                root,
                Size {
                    width: AvailableSpace::MaxContent,
                    height: AvailableSpace::MaxContent,
                },
            )
            .unwrap();

            let layout = taffy_layout(taffy, child).unwrap();

            assert_eq!(layout.size.width, 100.0);
            assert_eq!(layout.size.height, 100.0);

            taffy_release(taffy);
        }
    }

    #[test]
    fn set_children() {
        unsafe {
            let taffy = taffy_new();

            let child = taffy_new_leaf(
                taffy,
                Style {
                    size: Size {
                        width: Dimension::Auto,
                        height: Dimension::Auto,
                    },
                    flex_grow: 1.0,
                    ..Default::default()
                },
            )
            .unwrap();

            let root = taffy_new_leaf(
                taffy,
                Style {
                    size: Size {
                        width: Dimension::Length(100.0),
                        height: Dimension::Length(100.0),
                    },
                    ..Default::default()
                },
            )
            .unwrap();
            taffy_set_children(taffy, root, Slice::new(&mut [child]));

            taffy_compute_layout(
                taffy,
                root,
                Size {
                    width: AvailableSpace::MaxContent,
                    height: AvailableSpace::MaxContent,
                },
            )
            .unwrap();

            let layout = taffy_layout(taffy, child).unwrap();

            assert_eq!(layout.size.width, 100.0);
            assert_eq!(layout.size.height, 100.0);

            taffy_release(taffy);
        }
    }

    #[test]
    fn remove_child() {
        unsafe {
            let taffy = taffy_new();

            let child = taffy_new_leaf(taffy, Style::default()).unwrap();
            let root =
                taffy_new_with_children(taffy, Style::default(), Slice::new(&mut [child])).unwrap();

            assert_eq!(taffy_remove_child(taffy, root, child).unwrap(), child);
        }
    }

    #[test]
    fn remove_child_at_index() {
        unsafe {
            let taffy = taffy_new();

            let child0 = taffy_new_leaf(taffy, Style::default()).unwrap();
            let child1 = taffy_new_leaf(taffy, Style::default()).unwrap();
            let root =
                taffy_new_with_children(taffy, Style::default(), Slice::new(&mut [child0, child1]))
                    .unwrap();

            assert_eq!(taffy_remove_child_at_index(taffy, root, 1).unwrap(), child1);
            assert_eq!(taffy_remove_child_at_index(taffy, root, 0).unwrap(), child0);
        }
    }

    #[test]
    fn replace_child_at_index() {
        unsafe {
            let taffy = taffy_new();

            let child0 = taffy_new_leaf(taffy, Style::default()).unwrap();
            let child1 = taffy_new_leaf(taffy, Style::default()).unwrap();
            let root =
                taffy_new_with_children(taffy, Style::default(), Slice::new(&mut [child0, child1]))
                    .unwrap();

            assert_eq!(
                taffy_replace_child_at_index(taffy, root, 1, child0).unwrap(),
                child1
            );
        }
    }

    #[test]
    fn child_at_index() {
        unsafe {
            let taffy = taffy_new();

            let child0 = taffy_new_leaf(taffy, Style::default()).unwrap();
            let child1 = taffy_new_leaf(taffy, Style::default()).unwrap();
            let root =
                taffy_new_with_children(taffy, Style::default(), Slice::new(&mut [child0, child1]))
                    .unwrap();

            assert_eq!(taffy_child_at_index(taffy, root, 0).unwrap(), child0);
            assert_eq!(taffy_child_at_index(taffy, root, 1).unwrap(), child1);
        }
    }

    #[test]
    fn child_count() {
        unsafe {
            let taffy = taffy_new();

            let child0 = taffy_new_leaf(taffy, Style::default()).unwrap();
            let child1 = taffy_new_leaf(taffy, Style::default()).unwrap();
            let root =
                taffy_new_with_children(taffy, Style::default(), Slice::new(&mut [child0, child1]))
                    .unwrap();

            assert_eq!(taffy_child_count(taffy, root).unwrap(), 2);
        }
    }

    #[test]
    fn children() {
        unsafe {
            let taffy = taffy_new();

            let child0 = taffy_new_leaf(taffy, Style::default()).unwrap();
            let child1 = taffy_new_leaf(taffy, Style::default()).unwrap();
            let root =
                taffy_new_with_children(taffy, Style::default(), Slice::new(&mut [child0, child1]))
                    .unwrap();

            let mut children = Vec::with_capacity(2);
            taffy_children(taffy, root, NonNull::new(children.as_mut_ptr())).unwrap();
            children.set_len(2);

            assert_eq!(children, [child0, child1]);
        }
    }

    #[test]
    fn set_style() {
        unsafe {
            let taffy = taffy_new();

            let child = taffy_new_leaf(taffy, Style::default()).unwrap();
            let root =
                taffy_new_with_children(taffy, Style::default(), Slice::new(&mut [child])).unwrap();

            taffy_compute_layout(
                taffy,
                root,
                Size {
                    width: AvailableSpace::MaxContent,
                    height: AvailableSpace::MaxContent,
                },
            )
            .unwrap();

            let layout = taffy_layout(taffy, child).unwrap();

            assert_eq!(layout.size.width, 0.0);
            assert_eq!(layout.size.height, 0.0);

            taffy_set_style(
                taffy,
                child,
                Style {
                    size: Size {
                        width: Dimension::Auto,
                        height: Dimension::Auto,
                    },
                    flex_grow: 1.0,
                    ..Default::default()
                },
            )
            .unwrap();
            taffy_set_style(
                taffy,
                root,
                Style {
                    size: Size {
                        width: Dimension::Length(100.0),
                        height: Dimension::Length(100.0),
                    },
                    ..Default::default()
                },
            )
            .unwrap();

            taffy_compute_layout(
                taffy,
                root,
                Size {
                    width: AvailableSpace::MaxContent,
                    height: AvailableSpace::MaxContent,
                },
            )
            .unwrap();

            let layout = taffy_layout(taffy, child).unwrap();

            assert_eq!(layout.size.width, 100.0);
            assert_eq!(layout.size.height, 100.0);

            taffy_release(taffy);
        }
    }
}
