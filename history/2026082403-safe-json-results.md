# Safe JSON results and conversion allocation

- Invalid JSON is converted to ordinary error data instead of panicking inside
  the native boundary.
- Public wrappers use data-level `:ok` / `:err` payloads across the dylib ABI,
  then restore exceptions or typed `Result` in Calcit. This avoids unwinding
  Rust-owned errors after the dynamic-library call has returned.
- JSON-to-EDN conversion borrows the parsed tree and preallocates collection
  storage, avoiding recursive subtree clones and repeated vector growth.
- `parse-result` and `stringify-result` expose typed `Result` values for callers
  that want ordinary error flow instead of exceptions.
- Their payload remains `Dynamic` because JSON maps and arrays are recursively
  heterogeneous; those two reviewed native boundaries are recorded in the v2
  quality baseline without introducing `unsafe-coerce`.
- The project now targets Calcit 0.13.40.
