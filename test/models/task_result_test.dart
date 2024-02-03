import 'package:execution_metrics/mappers/task_result_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskResult', () {
    final taskResult = TaskResult(
      taskName: 'Test Task',
      minutes: 2,
      seconds: 30,
      milliseconds: 500,
    );

    test('Initial values', () {
      expect(taskResult.taskName, equals('Test Task'));
      expect(taskResult.minutes, equals(2));
      expect(taskResult.seconds, equals(30));
      expect(taskResult.milliseconds, equals(500));
    });

    test('Minutes to seconds conversion', () {
      expect(taskResult.minutes * 60, equals(120));
    });

    test('Seconds to milliseconds conversion', () {
      expect(taskResult.seconds * 1000, equals(30000));
    });
  });
}
