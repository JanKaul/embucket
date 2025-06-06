#![allow(clippy::unwrap_used, clippy::expect_used)]

use crate::tests::common::{Entity, Op, req, ui_test_op};
use crate::tests::server::run_test_server;
use crate::volumes::models::{
    AwsAccessKeyCredentials, AwsCredentials, FileVolume, S3Volume, VolumeCreatePayload,
    VolumeCreateResponse, VolumeType, VolumesResponse,
};
use http::Method;
use serde_json;

#[tokio::test]
#[allow(clippy::too_many_lines)]
async fn test_ui_volumes() {
    let addr = run_test_server().await;
    let client = reqwest::Client::new();

    // memory volume with empty ident create Ok
    let expected = VolumeCreatePayload {
        name: "embucket1".to_string(),
        volume: VolumeType::Memory,
    };
    let res = ui_test_op(addr, Op::Create, None, &Entity::Volume(expected.clone())).await;
    assert_eq!(200, res.status());
    let VolumeCreateResponse(created) = res.json().await.unwrap();
    assert_eq!(expected.name, created.name);

    // memory volume with empty ident create Ok
    let payload = r#"{"name":"embucket2","type": "file", "path":"/tmp/data"}"#;
    let expected: VolumeCreatePayload = serde_json::from_str(payload).unwrap();
    let res = ui_test_op(addr, Op::Create, None, &Entity::Volume(expected.clone())).await;
    // let res = create_test_volume(addr, &expected).await;
    assert_eq!(200, res.status());
    let VolumeCreateResponse(created) = res.json().await.unwrap();
    assert_eq!(expected.name, created.name);

    let expected = VolumeCreatePayload {
        name: "embucket2".to_string(),
        volume: VolumeType::File(FileVolume {
            path: "/tmp/data".to_string(),
        }),
    };
    let res = ui_test_op(addr, Op::Create, None, &Entity::Volume(expected.clone())).await;
    // let res = create_test_volume(addr, &expected).await;
    assert_eq!(409, res.status());

    // memory volume with empty ident create Ok
    let expected = VolumeCreatePayload {
        name: "embucket3".to_string(),
        volume: VolumeType::S3(S3Volume {
            region: Some("us-west-1".to_string()),
            bucket: Some("embucket".to_string()),
            endpoint: Some("http://localhost:9000".to_string()),
            skip_signature: None,
            metadata_endpoint: None,
            credentials: Some(AwsCredentials::AccessKey(AwsAccessKeyCredentials {
                aws_access_key_id: "********".to_string(),
                aws_secret_access_key: "********".to_string(),
            })),
        }),
    };
    let res = ui_test_op(addr, Op::Create, None, &Entity::Volume(expected.clone())).await;
    // let res = create_test_volume(addr, &expected).await;
    assert_eq!(200, res.status());
    let VolumeCreateResponse(created) = res.json().await.unwrap();
    assert_eq!(expected.name, created.name);

    //Get list volumes
    let res = req(
        &client,
        Method::GET,
        &format!("http://{addr}/ui/volumes",).to_string(),
        String::new(),
    )
    .await
    .unwrap();
    assert_eq!(http::StatusCode::OK, res.status());
    let volumes_response: VolumesResponse = res.json().await.unwrap();
    assert_eq!(3, volumes_response.items.len());
    assert_eq!(
        "embucket3".to_string(),
        volumes_response.items.first().unwrap().name
    );

    //Get list volumes with parameters
    let res = req(
        &client,
        Method::GET,
        &format!("http://{addr}/ui/volumes?limit=2",).to_string(),
        String::new(),
    )
    .await
    .unwrap();
    assert_eq!(http::StatusCode::OK, res.status());
    let volumes_response: VolumesResponse = res.json().await.unwrap();
    assert_eq!(2, volumes_response.items.len());
    assert_eq!(
        "embucket2".to_string(),
        volumes_response.items.last().unwrap().name
    );

    //Get list volumes with parameters
    let res = req(
        &client,
        Method::GET,
        &format!("http://{addr}/ui/volumes?offset=2",).to_string(),
        String::new(),
    )
    .await
    .unwrap();
    assert_eq!(http::StatusCode::OK, res.status());
    let volumes_response: VolumesResponse = res.json().await.unwrap();
    assert_eq!(1, volumes_response.items.len());
    assert_eq!(
        "embucket1".to_string(),
        volumes_response.items.first().unwrap().name
    );

    //Create a volume with diffrent name
    let expected = VolumeCreatePayload {
        name: "icebucket1".to_string(),
        volume: VolumeType::Memory,
    };
    let res = ui_test_op(addr, Op::Create, None, &Entity::Volume(expected.clone())).await;
    assert_eq!(200, res.status());
    let VolumeCreateResponse(created) = res.json().await.unwrap();
    assert_eq!(expected.name, created.name);

    //Get list volumes
    let res = req(
        &client,
        Method::GET,
        &format!("http://{addr}/ui/volumes",).to_string(),
        String::new(),
    )
    .await
    .unwrap();
    assert_eq!(http::StatusCode::OK, res.status());
    let volumes_response: VolumesResponse = res.json().await.unwrap();
    assert_eq!(4, volumes_response.items.len());

    //Get list volumes with parameters
    let res = req(
        &client,
        Method::GET,
        &format!("http://{addr}/ui/volumes?search=embucket",).to_string(),
        String::new(),
    )
    .await
    .unwrap();
    assert_eq!(http::StatusCode::OK, res.status());
    let volumes_response: VolumesResponse = res.json().await.unwrap();
    assert_eq!(3, volumes_response.items.len());

    //Get list volumes with parameters
    let res = req(
        &client,
        Method::GET,
        &format!("http://{addr}/ui/volumes?search=embucket&orderDirection=ASC",).to_string(),
        String::new(),
    )
    .await
    .unwrap();
    assert_eq!(http::StatusCode::OK, res.status());
    let volumes_response: VolumesResponse = res.json().await.unwrap();
    assert_eq!(3, volumes_response.items.len());
    assert_eq!(
        "embucket1".to_string(),
        volumes_response.items.first().unwrap().name
    );

    //Get list volumes with parameters
    let res = req(
        &client,
        Method::GET,
        &format!("http://{addr}/ui/volumes?search=ice",).to_string(),
        String::new(),
    )
    .await
    .unwrap();
    assert_eq!(http::StatusCode::OK, res.status());
    let volumes_response: VolumesResponse = res.json().await.unwrap();
    assert_eq!(1, volumes_response.items.len());
    assert_eq!(
        "icebucket1".to_string(),
        volumes_response.items.first().unwrap().name
    );

    //Delete volume
    let res = req(
        &client,
        Method::DELETE,
        &format!("http://{addr}/ui/volumes/embucket1",).to_string(),
        String::new(),
    )
    .await
    .unwrap();
    assert_eq!(http::StatusCode::OK, res.status());

    //Get list volumes
    let res = req(
        &client,
        Method::GET,
        &format!("http://{addr}/ui/volumes",).to_string(),
        String::new(),
    )
    .await
    .unwrap();
    assert_eq!(http::StatusCode::OK, res.status());
    let volumes_response: VolumesResponse = res.json().await.unwrap();
    assert_eq!(3, volumes_response.items.len());
}
