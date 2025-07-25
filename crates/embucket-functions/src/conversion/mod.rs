pub mod to_boolean;
pub mod to_time;

pub mod to_array;
pub mod to_binary;
pub mod to_variant;

use datafusion_expr::ScalarUDF;
use datafusion_expr::registry::FunctionRegistry;
use std::sync::Arc;
pub use to_binary::ToBinaryFunc;
pub use to_boolean::ToBooleanFunc;
pub use to_time::ToTimeFunc;

pub fn register_udfs(registry: &mut dyn FunctionRegistry) -> datafusion_common::Result<()> {
    let functions: Vec<Arc<ScalarUDF>> = vec![
        to_array::get_udf(),
        to_variant::get_udf(),
        Arc::new(ScalarUDF::from(ToBinaryFunc::new(false))),
        Arc::new(ScalarUDF::from(ToBinaryFunc::new(true))),
        Arc::new(ScalarUDF::from(ToBooleanFunc::new(false))),
        Arc::new(ScalarUDF::from(ToBooleanFunc::new(true))),
        Arc::new(ScalarUDF::from(ToTimeFunc::new(false))),
        Arc::new(ScalarUDF::from(ToTimeFunc::new(true))),
    ];
    for func in functions {
        registry.register_udf(func)?;
    }

    Ok(())
}
