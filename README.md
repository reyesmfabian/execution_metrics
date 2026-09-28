# Execution Metrics

[![pub package](https://img.shields.io/pub/v/execution_metrics.svg)](https://pub.dev/packages/execution_metrics)
[![CI](https://github.com/reyesmfabian/execution_metrics/actions/workflows/ci.yml/badge.svg)](https://github.com/reyesmfabian/execution_metrics/actions/workflows/ci.yml)

Measure how long your functions take in Dart and Flutter apps, and get a
readable report in the console.

## Installation

```sh
dart pub add execution_metrics   # or: flutter pub add execution_metrics
```

## Usage

```dart
import 'package:execution_metrics/execution_metrics.dart';

Future<void> main() async {
  // Asynchronous task: the action's value is returned.
  final data = await ExecutionMetrics.runAsync(
    taskName: 'Load data',
    deviceInfo: 'Pixel 8 - Android 15', // optional
    action: () => fetchData(),
  );

  // Synchronous task.
  ExecutionMetrics.run(
    taskName: 'Parse',
    action: () => parse(data),
  );

  // Use the callback to log or store results.
  ExecutionMetrics.run(
    taskName: 'Logged task',
    action: () => print('Working...'),
    callback: (result) {
      print('Task took ${result.totalMilliseconds} ms');
    },
  );

  // Manual start / stop.
  final metrics = ExecutionMetrics()..start(taskName: 'Manual');
  // ... work ...
  final result = metrics.stop();
  print(result.elapsed);
}
```

Each measurement prints a report like this:

```
╔════════════════════════════════════════════════════════════════════╗
║                          Execution Result                          ║
╠════════════════════════════════════════════════════════════════════╣
║                             Load data                              ║
╠════════════════════════════════════════════════════════════════════╣
║                        Pixel 8 - Android 15                        ║
╠══════════════════════╦══════════════════════╦══════════════════════╣
║       Minutes        ║       Seconds        ║     Milliseconds     ║
╠══════════════════════╬══════════════════════╬══════════════════════╣
║          0           ║          2           ║          4           ║
╚══════════════════════╩══════════════════════╩══════════════════════╝
```

## `TaskResult`

| Member | Description |
|---|---|
| `taskName` | Name given to the task. |
| `deviceInfo` | Optional device description, `null` if not provided. |
| `elapsed` | Total time, as a `Duration`. |
| `totalMilliseconds` | Total time in milliseconds. |
| `minutes`, `seconds`, `milliseconds` | Components of `elapsed` (seconds are 0-59, milliseconds 0-999). Not totals. |
| `toJson()` / `TaskResult.fromJson()` | JSON conversion (also `taskResultToJson` / `taskResultFromJson`). |

## Configuration

```dart
// Send the report somewhere else (e.g. your logger)...
ExecutionMetrics.logger = (report) => log(report, name: 'metrics');

// ...or disable it. Callbacks and return values keep working.
ExecutionMetrics.logger = null;

// Column width of the report (minimum 14).
ExecutionMetrics.colWidth = 18;
```

## Migrating from 2.x

- Use `result.elapsed` or `result.totalMilliseconds` for the total time;
  `seconds` and `milliseconds` were always only components.
- Build `TaskResult` with `elapsed: Duration(...)` instead of
  `minutes`/`seconds`/`milliseconds`.
- Import only `package:execution_metrics/execution_metrics.dart`.
- `stop()` without `start()` now throws a `StateError`.
- `boxContentWidth` is read-only; set `colWidth` instead.
