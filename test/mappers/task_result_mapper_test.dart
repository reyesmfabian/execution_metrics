import 'package:execution_metrics/mappers/task_result_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('TaskResult', () {
    test('fromJson', () {
      const jsonString =
          '{"taskName":"Test Task","minutes":2,"seconds":30,"milliseconds":500,"deviceInfo": "iPhone 7 - iOS 15.8.3"}';

      final result = taskResultFromJson(jsonString);

      expect(result.taskName, equals('Test Task'));
      expect(result.minutes, equals(2));
      expect(result.seconds, equals(30));
      expect(result.milliseconds, equals(500));
      expect(result.deviceInfo, equals('iPhone 7 - iOS 15.8.3'));
    });

    test('toJson', () {
      final taskResult = TaskResult(
        taskName: 'Test Task',
        minutes: 2,
        seconds: 30,
        milliseconds: 500,
        deviceInfo: 'iPhone 7 - iOS 15.8.3',
      );

      final jsonString = taskResultToJson(taskResult);
      const expectedJsonString =
          '{"taskName":"Test Task","minutes":2,"seconds":30,"milliseconds":500,"deviceInfo":"iPhone 7 - iOS 15.8.3"}';

      expect(jsonString, equals(expectedJsonString));
    });
  });
}
