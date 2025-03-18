import 'package:execution_metrics/execution_metrics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Start and stop', () {
    final executionMetrics = ExecutionMetrics();
    executionMetrics.start(taskName: 'Test Task');
    final result = executionMetrics.stop();

    expect(result.taskName, 'Test Task');
    expect(result.minutes, isNonNegative);
    expect(result.seconds, isNonNegative);
    expect(result.milliseconds, isNonNegative);
  });

  test('Start and stop with device info', () {
    final executionMetrics = ExecutionMetrics();
    executionMetrics.start(taskName: 'Test Task', deviceInfo: 'Test Device');
    final result = executionMetrics.stop();

    expect(result.taskName, 'Test Task');
    expect(result.deviceInfo, 'Test Device');
    expect(result.minutes, isNonNegative);
    expect(result.seconds, isNonNegative);
    expect(result.milliseconds, isNonNegative);
  });

  test('Stop without start', () {
    final executionMetrics = ExecutionMetrics();
    expect(() => executionMetrics.stop(), throwsA(isA<StateError>()));
  });
}
