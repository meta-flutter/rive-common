use taffy::{style, style_helpers::TaffyGridLine};

use super::{
    geometry::{Line, MinMax, Point, Rect, Size},
    Slice,
};

#[derive(Clone, Copy, Debug)]
#[repr(u8)]
pub enum AlignContent {
    None,
    Start,
    End,
    FlexStart,
    FlexEnd,
    Center,
    Stretch,
    SpaceBetween,
    SpaceEvenly,
    SpaceAround,
}

impl From<AlignContent> for Option<style::AlignContent> {
    fn from(value: AlignContent) -> Self {
        match value {
            AlignContent::None => None,
            AlignContent::Start => Some(style::AlignContent::Start),
            AlignContent::End => Some(style::AlignContent::End),
            AlignContent::FlexStart => Some(style::AlignContent::FlexStart),
            AlignContent::FlexEnd => Some(style::AlignContent::FlexEnd),
            AlignContent::Center => Some(style::AlignContent::Center),
            AlignContent::Stretch => Some(style::AlignContent::Stretch),
            AlignContent::SpaceBetween => Some(style::AlignContent::SpaceBetween),
            AlignContent::SpaceEvenly => Some(style::AlignContent::SpaceEvenly),
            AlignContent::SpaceAround => Some(style::AlignContent::SpaceAround),
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(u8)]
pub enum AlignItems {
    None,
    Start,
    End,
    FlexStart,
    FlexEnd,
    Center,
    Baseline,
    Stretch,
}

impl From<AlignItems> for Option<style::AlignItems> {
    fn from(value: AlignItems) -> Self {
        match value {
            AlignItems::None => None,
            AlignItems::Start => Some(style::AlignItems::Start),
            AlignItems::End => Some(style::AlignItems::End),
            AlignItems::FlexStart => Some(style::AlignItems::FlexStart),
            AlignItems::FlexEnd => Some(style::AlignItems::FlexEnd),
            AlignItems::Center => Some(style::AlignItems::Center),
            AlignItems::Baseline => Some(style::AlignItems::Baseline),
            AlignItems::Stretch => Some(style::AlignItems::Stretch),
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(C, u8)]
pub enum AvailableSpace {
    Definite(f32),
    MinContent,
    MaxContent,
}

impl From<style::AvailableSpace> for AvailableSpace {
    fn from(value: style::AvailableSpace) -> Self {
        match value {
            style::AvailableSpace::Definite(s) => AvailableSpace::Definite(s),
            style::AvailableSpace::MinContent => AvailableSpace::MinContent,
            style::AvailableSpace::MaxContent => AvailableSpace::MaxContent,
        }
    }
}

impl From<AvailableSpace> for style::AvailableSpace {
    fn from(value: AvailableSpace) -> Self {
        match value {
            AvailableSpace::Definite(s) => style::AvailableSpace::Definite(s),
            AvailableSpace::MinContent => style::AvailableSpace::MinContent,
            AvailableSpace::MaxContent => style::AvailableSpace::MaxContent,
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(C, u8)]
pub enum Dimension {
    Length(f32),
    Percent(f32),
    Auto,
}

impl From<Dimension> for style::Dimension {
    fn from(value: Dimension) -> Self {
        match value {
            Dimension::Length(points) => style::Dimension::Length(points),
            Dimension::Percent(percent) => style::Dimension::Percent(percent),
            Dimension::Auto => style::Dimension::Auto,
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(u8)]
pub enum Display {
    Flex,
    Grid,
    None,
}

impl From<Display> for style::Display {
    fn from(value: Display) -> Self {
        match value {
            Display::Flex => style::Display::Flex,
            Display::Grid => style::Display::Grid,
            Display::None => style::Display::None,
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(u8)]
pub enum FlexDirection {
    Row,
    Column,
    RowReverse,
    ColumnReverse,
}

impl From<FlexDirection> for style::FlexDirection {
    fn from(value: FlexDirection) -> Self {
        match value {
            FlexDirection::Row => style::FlexDirection::Row,
            FlexDirection::Column => style::FlexDirection::Column,
            FlexDirection::RowReverse => style::FlexDirection::RowReverse,
            FlexDirection::ColumnReverse => style::FlexDirection::ColumnReverse,
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(u8)]
pub enum FlexWrap {
    NoWrap,
    Wrap,
    WrapReverse,
}

impl From<FlexWrap> for style::FlexWrap {
    fn from(value: FlexWrap) -> Self {
        match value {
            FlexWrap::NoWrap => style::FlexWrap::NoWrap,
            FlexWrap::Wrap => style::FlexWrap::Wrap,
            FlexWrap::WrapReverse => style::FlexWrap::WrapReverse,
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(u8)]
pub enum GridAutoFlow {
    Row,
    Column,
    RowDense,
    ColumnDense,
}

impl From<GridAutoFlow> for style::GridAutoFlow {
    fn from(value: GridAutoFlow) -> Self {
        match value {
            GridAutoFlow::Row => style::GridAutoFlow::Row,
            GridAutoFlow::Column => style::GridAutoFlow::Column,
            GridAutoFlow::RowDense => style::GridAutoFlow::RowDense,
            GridAutoFlow::ColumnDense => style::GridAutoFlow::ColumnDense,
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(C)]
pub struct GridLine(i16);

#[derive(Clone, Copy, Debug)]
#[repr(C, u8)]
pub enum GridPlacement {
    Auto,
    Line(GridLine),
    Span(u16),
}

impl From<GridPlacement> for style::GridPlacement {
    fn from(value: GridPlacement) -> Self {
        match value {
            GridPlacement::Auto => style::GridPlacement::Auto,
            GridPlacement::Line(l) => style::GridPlacement::from_line_index(l.0),
            GridPlacement::Span(t) => style::GridPlacement::Span(t),
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(C, u8)]
pub enum GridTrackRepetition {
    AutoFill,
    AutoFit,
    Count(u16),
}

impl From<GridTrackRepetition> for style::GridTrackRepetition {
    fn from(value: GridTrackRepetition) -> Self {
        match value {
            GridTrackRepetition::AutoFill => style::GridTrackRepetition::AutoFill,
            GridTrackRepetition::AutoFit => style::GridTrackRepetition::AutoFit,
            GridTrackRepetition::Count(c) => style::GridTrackRepetition::Count(c),
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(C, u8)]
pub enum LengthPercentage {
    Length(f32),
    Percent(f32),
}

impl From<LengthPercentage> for style::LengthPercentage {
    fn from(value: LengthPercentage) -> Self {
        match value {
            LengthPercentage::Length(points) => style::LengthPercentage::Length(points),
            LengthPercentage::Percent(percent) => style::LengthPercentage::Percent(percent),
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(C, u8)]
pub enum LengthPercentageAuto {
    Length(f32),
    Percent(f32),
    Auto,
}

impl From<LengthPercentageAuto> for style::LengthPercentageAuto {
    fn from(value: LengthPercentageAuto) -> Self {
        match value {
            LengthPercentageAuto::Length(points) => style::LengthPercentageAuto::Length(points),
            LengthPercentageAuto::Percent(percent) => style::LengthPercentageAuto::Percent(percent),
            LengthPercentageAuto::Auto => style::LengthPercentageAuto::Auto,
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(C, u8)]
pub enum MaxTrackSizingFunction {
    Fixed(LengthPercentage),
    MinContent,
    MaxContent,
    FitContent(LengthPercentage),
    Auto,
    Fraction(f32),
}

impl From<MaxTrackSizingFunction> for style::MaxTrackSizingFunction {
    fn from(value: MaxTrackSizingFunction) -> Self {
        match value {
            MaxTrackSizingFunction::Fixed(lp) => style::MaxTrackSizingFunction::Fixed(lp.into()),
            MaxTrackSizingFunction::MinContent => style::MaxTrackSizingFunction::MinContent,
            MaxTrackSizingFunction::MaxContent => style::MaxTrackSizingFunction::MaxContent,
            MaxTrackSizingFunction::FitContent(lp) => {
                style::MaxTrackSizingFunction::FitContent(lp.into())
            }
            MaxTrackSizingFunction::Auto => style::MaxTrackSizingFunction::Auto,
            MaxTrackSizingFunction::Fraction(f) => style::MaxTrackSizingFunction::Fraction(f),
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(C, u8)]
pub enum MinTrackSizingFunction {
    Fixed(LengthPercentage),
    MinContent,
    MaxContent,
    Auto,
}

impl From<MinTrackSizingFunction> for style::MinTrackSizingFunction {
    fn from(value: MinTrackSizingFunction) -> Self {
        match value {
            MinTrackSizingFunction::Fixed(lp) => style::MinTrackSizingFunction::Fixed(lp.into()),
            MinTrackSizingFunction::MinContent => style::MinTrackSizingFunction::MinContent,
            MinTrackSizingFunction::MaxContent => style::MinTrackSizingFunction::MaxContent,
            MinTrackSizingFunction::Auto => style::MinTrackSizingFunction::Auto,
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(u8)]
pub enum Position {
    Relative,
    Absolute,
}

impl From<Position> for style::Position {
    fn from(value: Position) -> Self {
        match value {
            Position::Relative => style::Position::Relative,
            Position::Absolute => style::Position::Absolute,
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(u8)]
pub enum Overflow {
    Visible,
    Hidden,
    Scroll,
}

impl From<Overflow> for style::Overflow {
    fn from(value: Overflow) -> Self {
        match value {
            Overflow::Visible => style::Overflow::Visible,
            Overflow::Hidden => style::Overflow::Hidden,
            Overflow::Scroll => style::Overflow::Scroll,
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(C, u8)]
pub enum TrackSizingFunction {
    Single(NonRepeatedTrackSizingFunction),
    Repeat(GridTrackRepetition, Slice<NonRepeatedTrackSizingFunction>),
}

impl TryFrom<TrackSizingFunction> for style::TrackSizingFunction {
    type Error = ();

    fn try_from(value: TrackSizingFunction) -> core::result::Result<Self, Self::Error> {
        Ok(match value {
            TrackSizingFunction::Single(f) => style::TrackSizingFunction::Single(f.into()),
            TrackSizingFunction::Repeat(r, fs) => {
                style::TrackSizingFunction::Repeat(r.into(), fs.try_into()?)
            }
        })
    }
}

pub type AlignSelf = AlignItems;

pub type JustifyContent = AlignContent;

pub type NonRepeatedTrackSizingFunction = MinMax<MinTrackSizingFunction, MaxTrackSizingFunction>;

#[derive(Clone, Debug)]
#[repr(C)]
pub struct Style {
    pub display: Display,
    pub overflow: Point<Overflow>,
    pub scrollbar_width: f32,
    pub position: Position,
    pub inset: Rect<LengthPercentageAuto>,
    pub size: Size<Dimension>,
    pub min_size: Size<Dimension>,
    pub max_size: Size<Dimension>,
    pub aspect_ratio: super::Option<f32>,
    pub margin: Rect<LengthPercentageAuto>,
    pub padding: Rect<LengthPercentage>,
    pub border: Rect<LengthPercentage>,
    pub align_items: AlignItems,
    pub align_self: AlignSelf,
    pub justify_items: AlignItems,
    pub justify_self: AlignSelf,
    pub align_content: AlignContent,
    pub justify_content: JustifyContent,
    pub gap: Size<LengthPercentage>,
    pub flex_direction: FlexDirection,
    pub flex_wrap: FlexWrap,
    pub flex_basis: Dimension,
    pub flex_grow: f32,
    pub flex_shrink: f32,
    pub grid_template_rows: Slice<TrackSizingFunction>,
    pub grid_template_columns: Slice<TrackSizingFunction>,
    pub grid_auto_rows: Slice<NonRepeatedTrackSizingFunction>,
    pub grid_auto_columns: Slice<NonRepeatedTrackSizingFunction>,
    pub grid_auto_flow: GridAutoFlow,
    pub grid_row: Line<GridPlacement>,
    pub grid_column: Line<GridPlacement>,
}

impl Default for Style {
    fn default() -> Self {
        Self {
            display: Display::Flex,
            overflow: Point {
                x: Overflow::Visible,
                y: Overflow::Visible,
            },
            scrollbar_width: 0.0,
            position: Position::Relative,
            inset: Rect::AUTO,
            size: Size::AUTO,
            min_size: Size::AUTO,
            max_size: Size::AUTO,
            aspect_ratio: super::Option::None,
            margin: Rect::<LengthPercentageAuto>::ZERO,
            padding: Rect::<LengthPercentage>::ZERO,
            border: Rect::<LengthPercentage>::ZERO,
            align_items: AlignItems::None,
            align_self: AlignSelf::None,
            justify_items: AlignItems::None,
            justify_self: AlignSelf::None,
            align_content: AlignContent::None,
            justify_content: JustifyContent::None,
            gap: Size::ZERO,
            flex_direction: FlexDirection::Row,
            flex_wrap: FlexWrap::NoWrap,
            flex_basis: Dimension::Auto,
            flex_grow: 0.0,
            flex_shrink: 1.0,
            grid_template_rows: Slice::EMPTY,
            grid_template_columns: Slice::EMPTY,
            grid_auto_rows: Slice::EMPTY,
            grid_auto_columns: Slice::EMPTY,
            grid_auto_flow: GridAutoFlow::Row,
            grid_row: Line {
                start: GridPlacement::Auto,
                end: GridPlacement::Auto,
            },
            grid_column: Line {
                start: GridPlacement::Auto,
                end: GridPlacement::Auto,
            },
        }
    }
}

impl TryFrom<Style> for style::Style {
    type Error = ();

    fn try_from(value: Style) -> core::result::Result<Self, Self::Error> {
        Ok(Self {
            display: value.display.into(),
            overflow: value.overflow.into(),
            scrollbar_width: value.scrollbar_width,
            position: value.position.into(),
            inset: value.inset.into(),
            size: value.size.into(),
            min_size: value.min_size.into(),
            max_size: value.max_size.into(),
            aspect_ratio: value.aspect_ratio.into(),
            margin: value.margin.into(),
            padding: value.padding.into(),
            border: value.border.into(),
            align_items: value.align_items.into(),
            align_self: value.align_self.into(),
            justify_items: value.justify_items.into(),
            justify_self: value.justify_self.into(),
            align_content: value.align_content.into(),
            justify_content: value.justify_content.into(),
            gap: value.gap.into(),
            flex_direction: value.flex_direction.into(),
            flex_wrap: value.flex_wrap.into(),
            flex_basis: value.flex_basis.into(),
            flex_grow: value.flex_grow,
            flex_shrink: value.flex_shrink,
            grid_template_rows: value.grid_template_rows.try_into()?,
            grid_template_columns: value.grid_template_columns.try_into()?,
            grid_auto_rows: value.grid_auto_rows.try_into()?,
            grid_auto_columns: value.grid_auto_columns.try_into()?,
            grid_auto_flow: value.grid_auto_flow.into(),
            grid_row: value.grid_row.into(),
            grid_column: value.grid_column.into(),
        })
    }
}
