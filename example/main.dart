import 'package:execution_metrics/execution_metrics.dart';

void main() async {
  final ExecutionMetrics executionMetrics = ExecutionMetrics();
  asyncFunctionCallback() async {
    await Future.delayed(const Duration(seconds: 5));
  }

  executionMetrics.start(taskName: 'Test Task Example');
  await asyncFunctionCallback();
  executionMetrics.stop();
}
