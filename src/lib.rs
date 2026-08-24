use cirru_edn::{Edn, EdnEnumView, EdnListView, EdnMapView, EdnStructView};
use cirru_parser::Cirru;
use json::JsonValue;
use std::{collections::HashMap, sync::Arc};

#[no_mangle]
pub fn abi_version() -> String {
  String::from("0.0.9")
}

#[no_mangle]
pub fn edn_version() -> String {
  cirru_edn::version().to_string()
}

#[no_mangle]
pub fn json_stringify(args: Vec<Edn>) -> Result<Edn, String> {
  json_stringify_impl(args)
}

fn json_stringify_impl(args: Vec<Edn>) -> Result<Edn, String> {
  if args.len() == 1 || args.len() == 2 {
    let pretty = if args.len() == 2 {
      match args[1] {
        Edn::Bool(b) => b,
        Edn::Nil => false,
        _ => return Err(format!("json-stringify expected 2nd arg to be bool, got {:?}", args)),
      }
    } else {
      false
    };
    let edn = &args[0];
    let json = edn_to_json(edn)?;
    if pretty {
      Ok(Edn::str(json.pretty(2)))
    } else {
      Ok(Edn::str(json.dump()))
    }
  } else {
    Err(format!("json-stringify expected 1 or 2 args, got {:?}", args))
  }
}

#[no_mangle]
pub fn json_parse(args: Vec<Edn>) -> Result<Edn, String> {
  json_parse_impl(args)
}

fn json_parse_impl(args: Vec<Edn>) -> Result<Edn, String> {
  if args.len() == 1 {
    if let Edn::Str(content) = &args[0] {
      let json = json::parse(content).map_err(|error| format!("json-parse failed: {error}"))?;
      Ok(json_to_edn(&json))
    } else {
      Err(format!("json-parse expected string, got {:?}", args))
    }
  } else {
    Err(format!("json-parse expected 1 arg, got {:?}", args))
  }
}

#[no_mangle]
pub fn json_stringify_result(args: Vec<Edn>) -> Result<Edn, String> {
  Ok(edn_result(json_stringify_impl(args)))
}

#[no_mangle]
pub fn json_parse_result(args: Vec<Edn>) -> Result<Edn, String> {
  Ok(edn_result(json_parse_impl(args)))
}

fn edn_result(result: Result<Edn, String>) -> Edn {
  match result {
    Ok(value) => Edn::enum_value("ok", vec![value]),
    Err(error) => Edn::enum_value("err", vec![Edn::str(error)]),
  }
}

/// convert json to edn
fn json_to_edn(json: &JsonValue) -> Edn {
  match json {
    JsonValue::Null => Edn::Nil,
    JsonValue::Short(s) => Edn::Str(Arc::from(s.to_string())),
    JsonValue::String(s) => Edn::str(s.as_str()),
    JsonValue::Number(n) => Edn::Number((*n).into()),
    JsonValue::Boolean(b) => Edn::Bool(*b),
    JsonValue::Array(arr) => {
      let mut vec = Vec::with_capacity(arr.len());
      for item in arr {
        vec.push(json_to_edn(item));
      }
      Edn::List(EdnListView(vec))
    }
    JsonValue::Object(obj) => {
      #[allow(clippy::mutable_key_type)]
      let mut map = HashMap::with_capacity(obj.len());
      for (k, v) in obj.iter() {
        map.insert(k.into(), json_to_edn(v));
      }
      Edn::Map(EdnMapView::from(map))
    }
  }
}

// convert edn to json
fn edn_to_json(edn: &Edn) -> Result<JsonValue, String> {
  match edn {
    Edn::Nil => Ok(JsonValue::Null),
    Edn::Str(s) => Ok(JsonValue::String(s.to_string())),
    Edn::Number(n) => Ok(JsonValue::Number((*n).into())),
    Edn::Bool(b) => Ok(JsonValue::Boolean(*b)),
    Edn::List(list) => {
      let mut arr = Vec::with_capacity(list.0.len());
      for item in list {
        arr.push(edn_to_json(item)?);
      }
      Ok(JsonValue::Array(arr))
    }
    Edn::Map(map) => {
      let mut obj = json::object::Object::new();
      for (k, v) in &map.0 {
        if let Edn::Str(k) = k {
          obj.insert(k, edn_to_json(v)?);
        } else if let Edn::Tag(k) = k {
          obj.insert(&k.arc_str(), edn_to_json(v)?);
        } else {
          return Err(format!("json-stringify expected string or tag map keys, got {k:?}"));
        }
      }
      Ok(JsonValue::Object(obj))
    }
    Edn::Symbol(s) => Ok(JsonValue::String(s.to_string())),
    Edn::Tag(s) => Ok(JsonValue::String(s.to_string())),
    Edn::Set(xs) => {
      let mut arr = Vec::with_capacity(xs.0.len());
      for x in &xs.0 {
        arr.push(edn_to_json(x)?);
      }
      Ok(JsonValue::Array(arr))
    }
    Edn::Enum(EdnEnumView { variant, extra, .. }) => {
      let mut arr = Vec::with_capacity(extra.len() + 1);
      arr.push(JsonValue::String(variant.to_string()));
      for item in extra {
        arr.push(edn_to_json(item)?);
      }
      Ok(JsonValue::Array(arr))
    }
    Edn::Quote(x) => cirru_to_json(x),
    Edn::Buffer(buf) => Ok(JsonValue::String(format!("0x{}", hex::encode(buf)))),
    Edn::Struct(EdnStructView { name: _r, pairs: entries }) => {
      let mut obj = json::object::Object::new();
      for (k, v) in entries {
        obj.insert(&k.arc_str(), edn_to_json(v)?);
      }
      Ok(JsonValue::Object(obj))
    }
    Edn::AnyRef(_r) => Err("any-ref is a reference of unknown".to_owned()),
    Edn::Atom(v) => edn_to_json(v),
  }
}

/// convert cirru into json
fn cirru_to_json(code: &Cirru) -> Result<JsonValue, String> {
  match code {
    Cirru::Leaf(s) => Ok(JsonValue::String(s.to_string())),
    Cirru::List(list) => {
      let mut arr = Vec::with_capacity(list.len());
      for item in list {
        arr.push(cirru_to_json(item)?);
      }
      Ok(JsonValue::Array(arr))
    }
  }
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn invalid_json_returns_an_error() {
    let error = json_parse(vec![Edn::str("{\"broken\":")]).expect_err("invalid JSON should not panic");
    assert!(error.starts_with("json-parse failed:"));
  }

  #[test]
  fn result_entrypoint_keeps_parse_errors_in_edn() {
    let result = json_parse_result(vec![Edn::str("{\"broken\":")]).expect("result entrypoint should not return a dylib error");
    let Edn::Enum(value) = result else {
      panic!("result entrypoint should return an enum value");
    };
    assert_eq!(value.variant.as_ref(), "err");
    assert_eq!(value.extra.len(), 1);
  }

  #[test]
  fn nested_json_is_converted_without_cloning_subtrees() {
    let parsed = json_parse(vec![Edn::str(r#"{"items":[1,true,null]}"#)]).expect("valid JSON should parse");
    let Edn::Map(values) = parsed else {
      panic!("JSON object should become an EDN map");
    };
    assert_eq!(values.0.len(), 1);
  }

  #[test]
  fn stringify_arity_message_matches_the_supported_api() {
    let error = json_stringify(vec![]).expect_err("stringify should reject missing data");
    assert!(error.contains("expected 1 or 2 args"));
  }
}
