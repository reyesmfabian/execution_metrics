import 'package:execution_metrics/execution_metrics.dart';

void main() async {
  // Example using runAsync helper with named parameters
  final result = await ExecutionMetrics.runAsync(
    taskName: 'Async Task Example',
    action: () async {
      await Future.delayed(const Duration(seconds: 2));
      return 'Task Completed';
    },
    callback: (result) {
      print('Callback: Task ${result.taskName} finished in ${result.seconds}s');
    },
  );

  print('Result: $result');

  // Example using run helper with named parameters
  ExecutionMetrics.run(
    taskName: 'Sync Task Example',
    action: () {
      print('Running sync task...');
    },
  );
}
