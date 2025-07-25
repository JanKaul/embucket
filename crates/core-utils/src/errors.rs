use bytes::Bytes;
use slatedb::SlateDBError;
use snafu::Location;
use snafu::prelude::*;
use std::fmt::Debug;

pub type Result<T> = std::result::Result<T, Error>;

#[derive(Snafu)]
#[snafu(visibility(pub))]
#[error_stack_trace::debug]
pub enum Error {
    #[snafu(display("SlateDB error: {error}"))]
    Database {
        #[snafu(source)]
        error: SlateDBError,
        #[snafu(implicit)]
        location: Location,
    },

    #[snafu(display("SlateDB error while fetching key {key}: {error}"))]
    KeyGet {
        key: String,
        #[snafu(source)]
        error: SlateDBError,
        #[snafu(implicit)]
        location: Location,
    },

    #[snafu(display("SlateDB error while deleting key {key}: {error}"))]
    KeyDelete {
        key: String,
        #[snafu(source)]
        error: SlateDBError,
        #[snafu(implicit)]
        location: Location,
    },

    #[snafu(display("SlateDB error while putting key {key}: {error}"))]
    KeyPut {
        key: String,
        #[snafu(source)]
        error: SlateDBError,
        #[snafu(implicit)]
        location: Location,
    },

    #[snafu(display("Error serializing value: {error}"))]
    SerializeValue {
        #[snafu(source)]
        error: serde_json::Error,
        #[snafu(implicit)]
        location: Location,
    },

    #[snafu(display("Deserialize error: {error}, key: {key:?}"))]
    DeserializeValue {
        #[snafu(source)]
        error: serde_json::Error,
        key: Bytes,
        #[snafu(implicit)]
        location: Location,
    },

    #[snafu(display("Key Not found"))]
    KeyNotFound {
        #[snafu(implicit)]
        location: Location,
    },

    #[snafu(display("Scan Failed: {error}"))]
    ScanFailed {
        #[snafu(source)]
        error: SlateDBError,
        #[snafu(implicit)]
        location: Location,
    },
}
