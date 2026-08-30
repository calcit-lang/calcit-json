---
title: "Typed JSON boundary"
summary: "Parse and serialize JSON through Result APIs, then validate decoded Dynamic data before it enters typed application state"
scope: "module"
kind: "guide"
category: "data"
aliases:
  - "calcit json"
  - "parse JSON"
  - "stringify JSON"
  - "JSON Result"
  - "invalid JSON"
  - "JSON boundary"
  - "JSON 数据边界"
entry_for:
  - "json.core/parse-result"
  - "json.core/stringify-result"
  - "json.core/parse"
  - "json.core/stringify"
---

# Typed JSON boundary

JSON is an external data format. Prefer `parse-result` and `stringify-result` when invalid input or unsupported values belong to normal control flow. Keep the raising `parse` and `stringify` helpers for startup configuration, tests, or other boundaries where failure should abort the current operation.

```cirru.no-check
let
    parsed $ json.core/parse-result "|{\"revision\": 4}"
  parsed.and-then $ fn (value)
    validate-message value
```

`parse-result` returns `Result<Dynamic, String>` because JSON alone does not prove an application schema. Validate required keys and value types, then construct a nominal Struct or Enum before dispatching the value to a serial updater or storing it in a snapshot.

`stringify-result` keeps unsupported EDN values and invalid map keys in the error branch. Serialize a typed protocol message at the network or storage adapter; do not place serialized JSON strings inside the application's canonical state merely to avoid defining the data type.

## Realtime protocol placement

For WebSocket traffic, decode JSON once at ingress, validate the operation/message envelope, and retain revision, acknowledgement, and resynchronization fields as typed data. At egress, serialize only after the updater has produced a valid response or patch message. A parser success means the text is valid JSON; it does not mean the message is current, authorized, or compatible with the active protocol revision.

For persisted data, migrate a copied snapshot first. Parse, validate, reconstruct the typed state, serialize it again, and compare the logical result before atomically replacing the live file.
