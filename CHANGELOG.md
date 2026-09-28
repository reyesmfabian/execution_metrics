## 3.0.0

- **Breaking:** now a pure Dart package (no Flutter dependency); works in Flutter, CLI and server apps. Requires Dart `>=3.0.0`.
- **Breaking:** `TaskResult` is built from a `Duration elapsed`. `minutes`, `seconds` and `milliseconds` are now getters; use `elapsed` or `totalMilliseconds` for the total time (`seconds` and `milliseconds` are only components, 0-59 / 0-999).
- **Breaking:** `stop()` without `start()`, or `start()` while running, throws a `StateError`.
- **Breaking:** `boxContentWidth` is derived from `colWidth` (read-only), so the report box always stays aligned.
- Fixed: reusing an instance accumulated the previous measurement.
- Fixed: `deviceInfo` is consistently `null` when absent and survives a JSON round trip. `toJson` adds `elapsedMicroseconds`; `fromJson` still reads the old format.
- Fixed: long task names are truncated instead of breaking the box.
- Fixed: in `run`/`runAsync`, a failing callback no longer hides the action's error.
- Added `ExecutionMetrics.logger` to redirect the report or disable it (`null`), `formatReport`, and `isRunning`.
- Added `==`, `hashCode` and `toString` to `TaskResult`, and a `const` constructor.
- Callbacks are typed `void Function(TaskResult)`.
- Code moved to `lib/src`; import `package:execution_metrics/execution_metrics.dart`. The old `mappers/` and `models/` imports still work but are deprecated.

## 2.0.0

- Added `run` and `runAsync` helpers with named parameters and return value passthrough.
- Enhanced callback to receive `TaskResult` object.
- Made print formatting configurable (`ExecutionMetrics.boxContentWidth`, `ExecutionMetrics.colWidth`).
- **Breaking:** the callback now receives a `TaskResult` instead of the previous value.

## 1.1.0

- Added optional `deviceInfo` parameter.

## 1.0.1

- Add flutter compatibility

## 1.0.0

- initial release
