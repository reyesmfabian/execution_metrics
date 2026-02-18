# Execution Metrics

## Usage

```dart
import 'package:execution_metrics/execution_metrics.dart';

void main() async {
  // Use runAsync for asynchronous tasks
  await ExecutionMetrics.runAsync(
    taskName: 'Async Operation',
    action: () async {
      await Future.delayed(const Duration(seconds: 2));
    },
  );

  // Use run for synchronous tasks
  ExecutionMetrics.run(
    taskName: 'Sync Operation',
    action: () {
      // Your code here
    },
  );

  // Use callback to log results
  ExecutionMetrics.run(
    taskName: 'Logged Task',
    action: () => print('Working...'),
    callback: (result) {
      print('Task took ${result.milliseconds}ms');
    },
  );
}
```
