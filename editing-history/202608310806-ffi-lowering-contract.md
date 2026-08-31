# Complete calcit-json FFI lowering metadata

- Upgraded the Calcit snapshot requirement to 0.13.70.
- Declared complete native sync lowering metadata for `json.core/parse` and
  `json.core/stringify` using `edn-buffer-v1` transport.
- Removed accidental FFI metadata from the compile-time `get-dylib-ext` macro.
- Documented why JSON `Dynamic` remains behind handwritten adapters in
  Interface IR v1.
- Added a CI assertion that guards both lowering metadata and the remaining
  explicit unsupported-type boundary.
