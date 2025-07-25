use axum::{Json, response::IntoResponse};
use error_stack::ErrorExt;
use error_stack_trace;
use http;
use serde::{Deserialize, Serialize};
use snafu::Location;
use snafu::prelude::*;

pub type Result<T> = std::result::Result<T, Error>;

#[derive(Debug)]
pub enum Operation {
    CreateNamespace,
    GetNamespace,
    DeleteNamespace,
    ListNamespaces,
    CreateTable,
    RegisterTable,
    CommitTable,
    GetTable,
    DeleteTable,
    ListTables,
}

#[derive(Snafu)]
#[snafu(visibility(pub))]
#[error_stack_trace::debug]
pub enum Error {
    #[snafu(display("[IcebergAPI] Operation '{operation:?}' failed. Metastore error: {source}"))]
    Metastore {
        operation: Operation,
        source: core_metastore::Error,
        #[snafu(implicit)]
        location: Location,
    },
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ErrorResponse {
    pub message: String,
    pub status_code: u16,
}

impl IntoResponse for Error {
    fn into_response(self) -> axum::response::Response {
        tracing::error!("{}", self.output_msg());
        let metastore_error = match self {
            Self::Metastore { source, .. } => source,
        };

        let message = metastore_error.to_string();
        let code = match metastore_error {
            core_metastore::Error::TableDataExists { .. }
            | core_metastore::Error::ObjectAlreadyExists { .. }
            | core_metastore::Error::VolumeAlreadyExists { .. }
            | core_metastore::Error::DatabaseAlreadyExists { .. }
            | core_metastore::Error::SchemaAlreadyExists { .. }
            | core_metastore::Error::TableAlreadyExists { .. }
            | core_metastore::Error::VolumeInUse { .. } => http::StatusCode::CONFLICT,
            core_metastore::Error::TableRequirementFailed { .. } => {
                http::StatusCode::UNPROCESSABLE_ENTITY
            }
            core_metastore::Error::VolumeValidationFailed { .. }
            | core_metastore::Error::VolumeMissingCredentials { .. }
            | core_metastore::Error::Validation { .. } => http::StatusCode::BAD_REQUEST,
            core_metastore::Error::CloudProviderNotImplemented { .. } => {
                http::StatusCode::PRECONDITION_FAILED
            }
            core_metastore::Error::VolumeNotFound { .. }
            | core_metastore::Error::DatabaseNotFound { .. }
            | core_metastore::Error::SchemaNotFound { .. }
            | core_metastore::Error::TableNotFound { .. }
            | core_metastore::Error::ObjectNotFound { .. } => http::StatusCode::NOT_FOUND,
            core_metastore::Error::ObjectStore { .. }
            | core_metastore::Error::ObjectStorePath { .. }
            | core_metastore::Error::CreateDirectory { .. }
            | core_metastore::Error::SlateDB { .. }
            | core_metastore::Error::UtilSlateDB { .. }
            | core_metastore::Error::Iceberg { .. }
            | core_metastore::Error::Serde { .. }
            | core_metastore::Error::TableMetadataBuilder { .. }
            | core_metastore::Error::TableObjectStoreNotFound { .. }
            | core_metastore::Error::UrlParse { .. } => http::StatusCode::INTERNAL_SERVER_ERROR,
        };

        let error = ErrorResponse {
            message,
            status_code: code.as_u16(),
        };
        (code, Json(error)).into_response()
    }
}
