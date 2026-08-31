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

See [Typed JSON boundary](docs/typed-json-boundary.md) for choosing the raising
or `Result` APIs and for keeping decoded data out of persistent state until it
has been validated. The page is indexed by `calcit docs read/search`.

Install to `~/.config/calcit/modules/`, compile and provide `*.{dylib,so}` file with `./build.sh`.

The native library exports C-safe buffer FFI v1 and requires Calcit 0.13.70 or
newer. Shared descriptors, buffer ownership, Cirru EDN transport, and adapters
come from [`calcit_native_ffi`](https://github.com/calcit-lang/calcit-native-ffi).

原生库要求 Calcit 0.13.70 或更新版本，并通过共享 `calcit_native_ffi`
维护 descriptor、buffer ownership、Cirru EDN transport 与 adapter，不再在本
仓库复制协议模板。Legacy Rust ABI symbols are intentionally no longer exported.

`json.core/parse` and `json.core/stringify` declare the native synchronous
lowering contract consumed by `calcit ffi export`. Their logical schemas retain
`Dynamic` at the JSON value boundary, so Interface IR v1 reports an explicit
unsupported-type diagnostic and keeps these adapters handwritten.

`json.core/parse` 与 `json.core/stringify` 已声明供 `calcit ffi export` 使用的
native sync lowering 合同。JSON 值边界仍保留 `Dynamic`，因此 Interface IR v1
会明确报告 unsupported-type，由本模块继续维护手写 adapter，而不是退化为不安全
的自动绑定。

### Workflow

https://github.com/calcit-lang/dylib-workflow

### License

MIT
