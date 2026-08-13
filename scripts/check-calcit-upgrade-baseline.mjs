import fs from "node:fs";
import { execFileSync } from "node:child_process";

const baseline = JSON.parse(fs.readFileSync(".calcit/upgrade/weak-types-baseline.json", "utf8"));
const run = (args, file) => {
  const output = JSON.parse(execFileSync("cr", ["calcit.cirru", ...args], { encoding: "utf8" }));
  fs.writeFileSync(file, JSON.stringify(output));
  return output.data.summary;
};
const checkTypes = run(["analyze", "check-types", "--summary-only", "--format", "json"], ".calcit/upgrade/check-types.json");
const weakTypes = run(["analyze", "weak-types", "--intent", "unresolved,declared-optional", "--summary-only", "--format", "json"], ".calcit/upgrade/weak-types.json");
const deprecated = run(["analyze", "deprecated", "--summary-only", "--format", "json"], ".calcit/upgrade/deprecated.json");
const current = {
  check_types_full: checkTypes.levels.full,
  check_types_partial: checkTypes.levels.partial,
  check_types_none: checkTypes.levels.none,
  weak_schema_dynamic: weakTypes.kinds["schema-dynamic"] ?? 0,
  weak_code_dynamic: weakTypes.kinds["code-dynamic"] ?? 0,
  weak_code_nil: weakTypes.kinds["code-nil"] ?? 0,
  weak_unresolved: weakTypes.intents.unresolved ?? 0,
  deprecated_calls: deprecated.calls,
};
const expected = {
  check_types_full: baseline.check_types.full,
  check_types_partial: baseline.check_types.partial,
  check_types_none: baseline.check_types.none,
  weak_schema_dynamic: baseline.weak_types.schema_dynamic,
  weak_code_dynamic: baseline.weak_types.code_dynamic,
  weak_code_nil: baseline.weak_types.code_nil,
  weak_unresolved: baseline.weak_types.unresolved,
  deprecated_calls: baseline.deprecated_calls,
};
const failures = [];
for (const key of Object.keys(current)) {
  if (!(key in expected)) failures.push(`${key}: missing baseline`);
  else if (!Number.isFinite(current[key]) || !Number.isFinite(expected[key])) failures.push(`${key}: non-finite metric`);
  else if (key === "check_types_full") {
    if (current[key] < expected[key]) failures.push(`${key}: ${current[key]} < ${expected[key]}`);
  } else if (current[key] > expected[key]) failures.push(`${key}: ${current[key]} > ${expected[key]}`);
}
for (const key of Object.keys(expected)) if (!(key in current)) failures.push(`${key}: unknown baseline metric`);
for (const key of Object.keys(current)) console.log(`${key}: ${current[key]} (baseline ${expected[key] ?? "missing"})`);
if (failures.length) { console.error(failures.join("\n")); process.exit(1); }
