use super::geometry::{Point, Size};

use taffy::tree;

#[derive(Clone, Copy, Debug)]
#[repr(C)]
pub struct Layout {
    pub order: u32,
    pub size: Size<f32>,
    pub location: Point<f32>,
}

impl From<tree::Layout> for Layout {
    fn from(value: tree::Layout) -> Self {
        Self {
            order: value.order,
            size: value.size.into(),
            location: value.location.into(),
        }
    }
}
