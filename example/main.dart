import 'package:execution_metrics/execution_metrics.dart';

Future<void> main() async {
  // Measure an asynchronous task and get its return value back.
  final result = await ExecutionMetrics.runAsync(
    taskName: 'Async Task Example',
    deviceInfo: 'Example device',
    action: () async {
      await Future<void>.delayed(const Duration(seconds: 2));
      return 'Task Completed';
    },
    callback: (result) {
      print('Callback: ${result.taskName} took '
          '${result.totalMilliseconds} ms');
    },
  );

  print('Result: $result');

  // Measure a synchronous task.
  ExecutionMetrics.run(
    taskName: 'Sync Task Example',
    action: () => print('Running sync task...'),
  );

  // Manual start/stop, without printing the report.
  ExecutionMetrics.logger = null;
  final metrics = ExecutionMetrics()..start(taskName: 'Manual');
  await Future<void>.delayed(const Duration(milliseconds: 300));
  final manual = metrics.stop();
  print('Manual: ${manual.elapsed}');
}
