#!/usr/bin/env bash

set -euo pipefail

case "$(uname -s)" in
  Darwin)
    library="dylibs/libcalcit_json.dylib"
    symbols="$(nm -gU "$library")"
    ;;
  Linux)
    library="dylibs/libcalcit_json.so"
    symbols="$(nm -D --defined-only "$library")"
    ;;
  *)
    echo "unsupported platform for symbol audit: $(uname -s)" >&2
    exit 1
    ;;
esac

expected=(
  calcit_ffi_buffer_version
  calcit_ffi_buffer_free
  json_stringify_calcit_ffi_v1
  json_parse_calcit_ffi_v1
  json_stringify_result_calcit_ffi_v1
  json_parse_result_calcit_ffi_v1
)

for symbol in "${expected[@]}"; do
  if ! grep -Eq "[[:space:]]_?${symbol}$" <<<"$symbols"; then
    echo "missing C-safe export: $symbol" >&2
    exit 1
  fi
done

if grep -Eq '[[:space:]]_?(json_stringify|json_parse|json_stringify_result|json_parse_result|abi_version|edn_version)$' <<<"$symbols"; then
  echo "legacy Rust ABI export is still visible" >&2
  exit 1
fi

echo "verified ${#expected[@]} C-safe calcit-json exports and no legacy Rust ABI symbols in $library"
