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

The native library exports C-safe buffer FFI v1 and requires Calcit 0.13.57 or
newer. Shared descriptors, buffer ownership, Cirru EDN transport, and adapters
come from [`calcit_native_ffi`](https://github.com/calcit-lang/calcit-native-ffi).

原生库要求 Calcit 0.13.57 或更新版本，并通过共享 `calcit_native_ffi`
维护 descriptor、buffer ownership、Cirru EDN transport 与 adapter，不再在本
仓库复制协议模板。Legacy Rust ABI symbols are intentionally no longer exported.

### Workflow

https://github.com/calcit-lang/dylib-workflow

### License

MIT
