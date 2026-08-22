2026-08-22 21:00 — Upgrade calcit-json and native quality gate

- Updated the Calcit toolchain to 0.13.29 and setup-calcit.
- Replaced the project-local Node.js analyzer checker with Calcit's native `analyze quality --baseline` gate.
- Removed the obsolete weak-types baseline and custom script.
- Verified Rust fmt/clippy/test/release build and Calcit check-only.
