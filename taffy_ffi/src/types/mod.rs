use alloc::vec::Vec;
use core::{mem, ptr::NonNull, slice};

use taffy::tree::{self, TaffyError, TaffyResult};

pub mod geometry;
pub mod layout;
pub mod style;

#[derive(Clone, Copy, Debug)]
pub enum Taffy {}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
#[repr(C)]
pub struct NodeId(u64);

impl From<tree::NodeId> for NodeId {
    fn from(value: tree::NodeId) -> Self {
        unsafe { mem::transmute(value) }
    }
}

impl From<NodeId> for tree::NodeId {
    fn from(value: NodeId) -> Self {
        tree::NodeId::new(value.0)
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(C)]
pub struct Unit(());

impl From<()> for Unit {
    fn from(_: ()) -> Self {
        Self(())
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(u8, C)]
pub enum Option<T> {
    Some(T),
    None,
}

impl<T> Option<T> {
    pub fn from<U: Into<T>>(option: core::option::Option<U>) -> Self {
        match option {
            Some(val) => Self::Some(val.into()),
            None => Self::None,
        }
    }

    pub fn into<U: From<T>>(self) -> core::option::Option<U> {
        match self {
            Self::Some(val) => Some(val.into()),
            Self::None => None,
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(C, u8)]
pub enum Error {
    ChildIndexOutOfBounds {
        parent: NodeId,
        child_index: usize,
        child_count: usize,
    },
    InvalidParentNode(NodeId),
    InvalidChildNode(NodeId),
    InvalidInputNode(NodeId),
    NullPointer,
}

#[derive(Clone, Copy, Debug)]
#[repr(C, u8)]
pub enum Result<T> {
    Ok(T),
    Err(Error),
}

impl<T> Result<T> {
    #[cfg(test)]
    pub fn unwrap(self) -> T {
        match self {
            Self::Ok(val) => val,
            Self::Err(e) => Err(e).unwrap(),
        }
    }
}

impl<T, U: From<T>> From<TaffyResult<T>> for Result<U> {
    fn from(value: TaffyResult<T>) -> Self {
        match value {
            Ok(val) => Result::Ok(val.into()),
            Err(err) => Result::Err(match err {
                TaffyError::ChildIndexOutOfBounds {
                    parent,
                    child_index,
                    child_count,
                } => Error::ChildIndexOutOfBounds {
                    parent: parent.into(),
                    child_index,
                    child_count,
                },
                TaffyError::InvalidParentNode(node) => Error::InvalidParentNode(node.into()),
                TaffyError::InvalidChildNode(node) => Error::InvalidChildNode(node.into()),
                TaffyError::InvalidInputNode(node) => Error::InvalidInputNode(node.into()),
            }),
        }
    }
}

#[derive(Clone, Copy, Debug)]
#[repr(C)]
pub struct Slice<T> {
    data: core::option::Option<NonNull<T>>,
    len: usize,
}

impl<T> Slice<T> {
    pub(crate) const EMPTY: Self = Self { data: None, len: 0 };

    #[cfg(test)]
    pub fn new(slice: &mut [T]) -> Self {
        Self {
            data: NonNull::new(slice.as_mut_ptr()),
            len: slice.len(),
        }
    }
}

impl TryFrom<Slice<NodeId>> for &[tree::NodeId] {
    type Error = ();

    fn try_from(value: Slice<NodeId>) -> core::result::Result<Self, Self::Error> {
        let mut data = value.data;

        if value.len == 0 {
            data = Some(NonNull::dangling());
        }

        Ok(unsafe { slice::from_raw_parts(data.ok_or(())?.cast().as_ptr(), value.len) })
    }
}

impl<T: Clone, U: TryFrom<T, Error = E>, E> TryFrom<Slice<T>> for Vec<U> {
    type Error = ();

    fn try_from(value: Slice<T>) -> core::result::Result<Self, Self::Error> {
        let mut data = value.data;

        if value.len == 0 {
            data = Some(NonNull::dangling());
        }

        let slice = unsafe { slice::from_raw_parts(data.ok_or(())?.as_ptr(), value.len) };

        slice
            .iter()
            .cloned()
            .map(|val| val.try_into().map_err(|_| ()))
            .collect()
    }
}
