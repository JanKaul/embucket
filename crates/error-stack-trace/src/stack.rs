// Copyright 2023 Greptime Team
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// --------------------------------------------------------------------------------
// Modifications by Embucket Team, 2025
// - Use a function instead of a closure in .map() calls
// - Add clippy rules to suppress warnings
// --------------------------------------------------------------------------------

#![allow(clippy::needless_pass_by_value)]
use proc_macro2::{Literal, Span, TokenStream as TokenStream2, TokenTree};
use quote::{quote, quote_spanned};
use syn::spanned::Spanned;
use syn::{Attribute, Ident, ItemEnum, Variant, parenthesized};

pub fn stack_trace_style_impl(args: TokenStream2, input: TokenStream2) -> TokenStream2 {
    let input_cloned: TokenStream2 = input.clone();

    #[allow(clippy::unwrap_used)]
    let error_enum_definition: ItemEnum = syn::parse2(input_cloned).unwrap();
    let enum_name = error_enum_definition.ident;

    let mut variants = vec![];

    for error_variant in error_enum_definition.variants {
        let variant = ErrorVariant::from_enum_variant(error_variant);
        variants.push(variant);
    }

    let transparent_fn = build_transparent_fn(enum_name.clone(), &variants);
    let debug_fmt_fn = build_debug_fmt_impl(enum_name.clone(), variants.clone());
    let next_fn = build_next_impl(enum_name.clone(), variants);
    let debug_impl = build_debug_impl(enum_name.clone());

    quote! {
        #args
        #input

        impl error_stack::StackError for #enum_name {
            #debug_fmt_fn
            #next_fn
            #transparent_fn
        }

        #debug_impl
    }
}

/// Generate `debug_fmt` fn.
///
/// The generated fn will be like:
/// ```rust, ignore
/// fn debug_fmt(&self, layer: usize, buf: &mut Vec<String>);
/// ```
fn build_debug_fmt_impl(enum_name: Ident, variants: Vec<ErrorVariant>) -> TokenStream2 {
    let match_arms = variants
        .iter()
        .map(ErrorVariant::to_debug_match_arm)
        .collect::<Vec<_>>();

    quote! {
        fn debug_fmt(&self, layer: usize, buf: &mut Vec<String>) {
            use #enum_name::*;
            match self {
                #(#match_arms)*
            }
        }
    }
}

/// Generate `next` fn.
///
/// The generated fn will be like:
/// ```rust, ignore
/// fn next(&self) -> Option<&dyn error_stack::ext::StackError>;
/// ```
fn build_next_impl(enum_name: Ident, variants: Vec<ErrorVariant>) -> TokenStream2 {
    let match_arms = variants
        .iter()
        .map(ErrorVariant::to_next_match_arm)
        .collect::<Vec<_>>();

    quote! {
        fn next(&self) -> Option<&dyn error_stack::StackError> {
            use #enum_name::*;
            match self {
                #(#match_arms)*
            }
        }
    }
}

/// Implement [`std::fmt::Debug`] via `debug_fmt`
fn build_debug_impl(enum_name: Ident) -> TokenStream2 {
    quote! {
        impl std::fmt::Debug for #enum_name {
            fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
                use error_stack::StackError;
                let mut buf = vec![];
                self.debug_fmt(0, &mut buf);
                write!(f, "{}", buf.join("\n"))
            }
        }
    }
}

#[allow(clippy::struct_excessive_bools)]
#[derive(Clone, Debug)]
struct ErrorVariant {
    name: Ident,
    fields: Vec<Ident>,
    has_location: bool,
    has_source: bool,
    has_external_cause: bool,
    display: TokenStream2,
    transparent: bool,
    span: Span,
    cfg_attr: Option<Attribute>,
}

impl ErrorVariant {
    /// Construct self from [Variant]
    fn from_enum_variant(variant: Variant) -> Self {
        let span = variant.span();
        let mut has_location = false;
        let mut has_source = false;
        let mut has_external_cause = false;

        for field in &variant.fields {
            if let Some(ident) = &field.ident {
                if ident == "location" {
                    has_location = true;
                } else if ident == "source" {
                    has_source = true;
                } else if ident == "error" {
                    has_external_cause = true;
                }
            }
        }

        let mut display = None;
        let mut transparent = false;
        let mut cfg_attr = None;
        for attr in variant.attrs {
            if attr.path().is_ident("snafu") {
                attr.parse_nested_meta(|meta| {
                    if meta.path.is_ident("display") {
                        let content;
                        parenthesized!(content in meta.input);
                        let display_ts: TokenStream2 = content.parse()?;
                        display = Some(display_ts);
                        Ok(())
                    } else if meta.path.is_ident("transparent") {
                        display = Some(TokenStream2::from(TokenTree::Literal(Literal::string(
                            "<transparent>",
                        ))));
                        transparent = true;
                        Ok(())
                    } else {
                        Err(meta.error("unrecognized repr"))
                    }
                })
                .unwrap_or_else(|e| panic!("{e}"));
            }

            if attr.path().is_ident("cfg") {
                cfg_attr = Some(attr);
            }
        }
        let display = display.unwrap_or_else(|| {
            panic!(
                r#"Error "{}" must be annotated with attribute "display" or "transparent"."#,
                variant.ident,
            )
        });

        let field_ident = variant
            .fields
            .iter()
            .map(|f| f.ident.clone().unwrap_or_else(|| Ident::new("_", f.span())))
            .collect();

        Self {
            name: variant.ident,
            fields: field_ident,
            has_location,
            has_source,
            has_external_cause,
            display,
            transparent,
            span,
            cfg_attr,
        }
    }

    /// Convert self into an match arm that will be used in [`build_debug_impl`].
    ///
    /// The generated match arm will be like:
    /// ```rust, ignore
    ///     ErrorKindWithSource { source, .. } => {
    ///         debug_fmt(source, layer + 1, buf);
    ///     },
    ///     ErrorKindWithoutSource { .. } => {
    ///        buf.push(format!("{layer}: {}, at {}", format!(#display), location)));
    ///     }
    /// ```
    ///
    /// The generated code assumes fn `debug_fmt`, var `layer`, var `buf` are in scope.
    fn to_debug_match_arm(&self) -> TokenStream2 {
        let name = &self.name;
        let fields = &self.fields;
        let display = &self.display;
        let cfg = if let Some(cfg) = &self.cfg_attr {
            quote_spanned!(cfg.span() => #cfg)
        } else {
            quote! {}
        };

        match (self.has_location, self.has_source, self.has_external_cause) {
            (true, true, _) => quote_spanned! {
               self.span => #cfg #[allow(unused_variables)] #name { #(#fields),*, } => {
                    buf.push(format!("{layer}: {}, at {}", format!(#display), location));
                    source.debug_fmt(layer + 1, buf);
                },
            },
            (true, false, true) => quote_spanned! {
                self.span => #cfg #[allow(unused_variables)] #name { #(#fields),* } => {
                    buf.push(format!("{layer}: {}, at {}", format!(#display), location));
                    buf.push(format!("{}: {:?}", layer + 1, error));
                },
            },
            (true, false, false) => quote_spanned! {
                self.span => #cfg #[allow(unused_variables)] #name { #(#fields),* } => {
                    buf.push(format!("{layer}: {}, at {}", format!(#display), location));
                },
            },
            (false, true, _) => quote_spanned! {
                self.span => #cfg #[allow(unused_variables)] #name { #(#fields),* } => {
                    buf.push(format!("{layer}: {}", format!(#display)));
                    source.debug_fmt(layer + 1, buf);
                },
            },
            (false, false, true) => quote_spanned! {
                self.span => #cfg #[allow(unused_variables)] #name { #(#fields),* } => {
                    buf.push(format!("{layer}: {}", format!(#display)));
                    buf.push(format!("{}: {:?}", layer + 1, error));
                },
            },
            (false, false, false) => quote_spanned! {
                self.span => #cfg #[allow(unused_variables)] #name { #(#fields),* } => {
                    buf.push(format!("{layer}: {}", format!(#display)));
                },
            },
        }
    }

    /// Convert self into an match arm that will be used in [`build_next_impl`].
    ///
    /// The generated match arm will be like:
    /// ```rust, ignore
    ///     ErrorKindWithSource { source, .. } => {
    ///         Some(source)
    ///     },
    ///     ErrorKindWithoutSource { .. } => {
    ///        None
    ///     }
    /// ```
    fn to_next_match_arm(&self) -> TokenStream2 {
        let name = &self.name;
        let fields = &self.fields;
        let cfg = if let Some(cfg) = &self.cfg_attr {
            quote_spanned!(cfg.span() => #cfg)
        } else {
            quote! {}
        };

        if self.has_source {
            quote_spanned! {
                self.span => #cfg #[allow(unused_variables)] #name { #(#fields),* } => {
                    Some(source)
                },
            }
        } else {
            quote_spanned! {
                self.span => #cfg #[allow(unused_variables)] #name { #(#fields),* } =>{
                    None
                }
            }
        }
    }

    fn build_transparent_match_arm(&self) -> TokenStream2 {
        let cfg = if let Some(cfg) = &self.cfg_attr {
            quote_spanned!(cfg.span() => #cfg)
        } else {
            quote! {}
        };
        let name = &self.name;
        let fields = &self.fields;

        if self.transparent {
            quote_spanned! {
                self.span => #cfg #[allow(unused_variables)] #name { #(#fields),* } => {
                    true
                },
            }
        } else {
            quote_spanned! {
                self.span => #cfg #[allow(unused_variables)] #name { #(#fields),* } =>{
                    false
                }
            }
        }
    }
}

fn build_transparent_fn(enum_name: Ident, variants: &[ErrorVariant]) -> TokenStream2 {
    let match_arms = variants
        .iter()
        .map(ErrorVariant::build_transparent_match_arm)
        .collect::<Vec<_>>();

    quote! {
        fn transparent(&self) -> bool {
            use #enum_name::*;
            match self {
                #(#match_arms)*
            }
        }
    }
}
