import 'package:execution_metrics/execution_metrics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Start and stop', () {
    final executionMetrics = ExecutionMetrics();
    executionMetrics.start(taskName: 'Test Task');
    executionMetrics.stop();
  });
}
