import 'package:execution_metrics/execution_metrics.dart';
import 'package:test/test.dart';

void main() {
  group('TaskResult JSON', () {
    const taskResult = TaskResult(
      taskName: 'Test Task',
      elapsed: Duration(minutes: 2, seconds: 30, milliseconds: 500),
      deviceInfo: 'iPhone 7 - iOS 15.8.3',
    );

    test('toJson', () {
      expect(
        taskResultToJson(taskResult),
        '{"taskName":"Test Task","elapsedMicroseconds":150500000,'
        '"minutes":2,"seconds":30,"milliseconds":500,'
        '"deviceInfo":"iPhone 7 - iOS 15.8.3"}',
      );
    });

    test('toJson omits a null deviceInfo', () {
      const noDevice = TaskResult(taskName: 'T', elapsed: Duration.zero);

      expect(noDevice.toJson().containsKey('deviceInfo'), isFalse);
    });

    test('round trip', () {
      const noDevice = TaskResult(
        taskName: 'T',
        elapsed: Duration(microseconds: 1234567),
      );

      expect(taskResultFromJson(taskResultToJson(taskResult)), taskResult);
      expect(taskResultFromJson(taskResultToJson(noDevice)), noDevice);
    });

    test('fromJson accepts the legacy format', () {
      final result = taskResultFromJson(
        '{"taskName":"Test Task","minutes":2,"seconds":30,"milliseconds":500,'
        '"deviceInfo":"iPhone 7 - iOS 15.8.3"}',
      );

      expect(result, taskResult);
    });

    test('fromJson keeps a null deviceInfo as null', () {
      final result = taskResultFromJson(
        '{"taskName":"T","minutes":0,"seconds":1,"milliseconds":0,"deviceInfo":null}',
      );

      expect(result.deviceInfo, isNull);
      expect(result.elapsed, const Duration(seconds: 1));
    });
  });
}
