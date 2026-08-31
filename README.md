# Calcit JSON (archived / 已归档)

> [!IMPORTANT]
> This repository is frozen at `0.0.17` and archived. JSON parsing and encoding
> are built into Calcit; do not upgrade this native module for new Calcit
> releases or add new features here.
>
> 本仓库冻结于 `0.0.17` 并归档。JSON 解析与编码已内建到 Calcit；后续 Calcit
> 发版不再升级此 native 模块，也不在此增加功能。

## Migration / 迁移

- `json.core/parse-result text` → `text.parse-json` (returns `Result<Dynamic,String>`);
- `json.core/parse text` → core `json-parse text` when failure should raise;
- `json.core/stringify value` → core `json-stringify value`;
- pretty output → core `json-pretty value`;
- validate open JSON with `decode-map-as` / `try-decode-map-as` before it enters
  typed application state.

Existing tags and source remain available for old projects, but consumers should pin
`0.0.17` while migrating instead of following `main`.

旧项目仍可读取已有 tag 和源码，但应固定 `0.0.17` 并逐步迁移，不再依赖 `main`。

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
