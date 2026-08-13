# Calcit JSON 0.13.15 upgrade

- Migrated the dependency declaration to Calcit 0.13.15 while retaining the canonical `calcit.cirru` snapshot.
- Added concrete function and macro schemas for JSON APIs, test entry points, and dylib path helpers.
- Recorded the two intentional native JSON FFI `Dynamic` boundaries in the static-analysis baseline.
- Added CI checks for formatting, clippy, tests, snapshot validation, type coverage, weak types, deprecated calls, and the baseline gate.
