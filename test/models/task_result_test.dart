import 'package:execution_metrics/execution_metrics.dart';
import 'package:test/test.dart';

void main() {
  group('TaskResult', () {
    const taskResult = TaskResult(
      taskName: 'Test Task',
      elapsed: Duration(minutes: 2, seconds: 30, milliseconds: 500),
    );

    test('splits elapsed into components', () {
      expect(taskResult.minutes, 2);
      expect(taskResult.seconds, 30);
      expect(taskResult.milliseconds, 500);
    });

    test('exposes the total duration', () {
      expect(taskResult.totalMilliseconds, 150500);
      expect(taskResult.elapsed.inSeconds, 150);
    });

    test('minutes are not capped at 60', () {
      const long = TaskResult(taskName: 'Long', elapsed: Duration(hours: 1));

      expect(long.minutes, 60);
      expect(long.seconds, 0);
    });

    test('value equality', () {
      const same = TaskResult(
        taskName: 'Test Task',
        elapsed: Duration(minutes: 2, seconds: 30, milliseconds: 500),
      );

      expect(taskResult, same);
      expect(taskResult.hashCode, same.hashCode);
      expect(taskResult,
          isNot(const TaskResult(taskName: 'Other', elapsed: Duration.zero)));
    });

    test('toString', () {
      expect(taskResult.toString(), contains('Test Task'));
    });
  });
}
