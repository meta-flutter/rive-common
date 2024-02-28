use taffy::geometry as geom;

use super::style::{Dimension, LengthPercentage, LengthPercentageAuto};

#[derive(Clone, Copy, Debug)]
#[repr(C)]
pub struct Line<T> {
    pub start: T,
    pub end: T,
}

impl<T, U: From<T>> From<Line<T>> for geom::Line<U> {
    fn from(value: Line<T>) -> Self {
        Self {
            start: value.start.into(),
            end: value.end.into(),
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(C)]
pub struct MinMax<Min, Max> {
    pub min: Min,
    pub max: Max,
}

impl<MinT, MaxT, MinU: From<MinT>, MaxU: From<MaxT>> From<MinMax<MinT, MaxT>>
    for geom::MinMax<MinU, MaxU>
{
    fn from(value: MinMax<MinT, MaxT>) -> Self {
        Self {
            min: value.min.into(),
            max: value.max.into(),
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(C)]
pub struct Point<T> {
    pub x: T,
    pub y: T,
}

impl<T, U: From<T>> From<geom::Point<T>> for Point<U> {
    fn from(value: geom::Point<T>) -> Self {
        Self {
            x: value.x.into(),
            y: value.y.into(),
        }
    }
}

impl<T, U: From<T>> From<Point<T>> for geom::Point<U> {
    fn from(value: Point<T>) -> Self {
        Self {
            x: value.x.into(),
            y: value.y.into(),
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(C)]
pub struct Rect<T> {
    pub left: T,
    pub right: T,
    pub top: T,
    pub bottom: T,
}

impl Rect<LengthPercentage> {
    pub(crate) const ZERO: Self = Self {
        left: LengthPercentage::Length(0.0),
        right: LengthPercentage::Length(0.0),
        top: LengthPercentage::Length(0.0),
        bottom: LengthPercentage::Length(0.0),
    };
}

impl Rect<LengthPercentageAuto> {
    pub(crate) const AUTO: Self = Self {
        left: LengthPercentageAuto::Auto,
        right: LengthPercentageAuto::Auto,
        top: LengthPercentageAuto::Auto,
        bottom: LengthPercentageAuto::Auto,
    };

    pub(crate) const ZERO: Self = Self {
        left: LengthPercentageAuto::Length(0.0),
        right: LengthPercentageAuto::Length(0.0),
        top: LengthPercentageAuto::Length(0.0),
        bottom: LengthPercentageAuto::Length(0.0),
    };
}

impl<T, U: From<T>> From<Rect<T>> for geom::Rect<U> {
    fn from(value: Rect<T>) -> Self {
        Self {
            left: value.left.into(),
            right: value.right.into(),
            top: value.top.into(),
            bottom: value.bottom.into(),
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(C)]
pub struct Size<T> {
    pub width: T,
    pub height: T,
}

impl Size<Dimension> {
    pub(crate) const AUTO: Self = Self {
        width: Dimension::Auto,
        height: Dimension::Auto,
    };
}

impl Size<LengthPercentage> {
    pub(crate) const ZERO: Self = Self {
        width: LengthPercentage::Length(0.0),
        height: LengthPercentage::Length(0.0),
    };
}

impl<T, U: From<T>> From<geom::Size<T>> for Size<U> {
    fn from(value: geom::Size<T>) -> Self {
        Self {
            width: value.width.into(),
            height: value.height.into(),
        }
    }
}

impl<T, U: From<T>> From<Size<T>> for geom::Size<U> {
    fn from(value: Size<T>) -> Self {
        Self {
            width: value.width.into(),
            height: value.height.into(),
        }
    }
}
