# C-safe buffer FFI v1 / C 安全缓冲区 FFI v1

- Migrated all four JSON entry points from the Rust ABI fallback to C-safe buffer FFI v1.
- 将四个 JSON 入口从 Rust ABI fallback 迁移到 C 安全 buffer FFI v1。
- Added boundary validation, panic containment, output ownership, unit tests, real Calcit smoke coverage, and exported-symbol auditing.
- 增加边界校验、panic 隔离、输出所有权、单元测试、真实 Calcit smoke 与导出符号审计。
- Upgraded to Calcit 0.13.52, strict macro schemas, and `setup-calcit@v1.3.0`.
- 升级到 Calcit 0.13.52、严格 macro schema 与 `setup-calcit@v1.3.0`。
- Retained the four reviewed Dynamic slots at the recursive JSON-value boundary; the existing quality baseline remains unchanged.
- 保留递归 JSON 值边界上经审阅的四个 Dynamic slot；现有质量基线没有增加债务。
