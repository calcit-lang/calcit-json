## Calcit JSON

> based on [json](https://docs.rs/json/latest/json/).

### Usages

APIs:

```cirru
json.core/parse "|{\"a\": [\"b\", 2]}"

json.core/stringify $ {} (:a 1)
json.core/stringify ({} (:a 1)) true

; "typed Result APIs keep input failures in normal control flow"
json.core/parse-result "|{\"a\": 1}"
json.core/stringify-result $ {} (:a 1)
```

Install to `~/.config/calcit/modules/`, compile and provide `*.{dylib,so}` file with `./build.sh`.

The native library exports C-safe buffer FFI v1 and requires Calcit 0.13.52 or
newer. Legacy Rust ABI symbols are intentionally no longer exported.

### Workflow

https://github.com/calcit-lang/dylib-workflow

### License

MIT
