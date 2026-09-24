import 'package:execution_metrics/execution_metrics.dart';
import 'package:test/test.dart';

void main() {
  late List<String> logs;
  late ExecutionLogger? originalLogger;
  late int originalColWidth;

  setUp(() {
    logs = [];
    originalLogger = ExecutionMetrics.logger;
    originalColWidth = ExecutionMetrics.colWidth;
    ExecutionMetrics.logger = logs.add;
  });

  tearDown(() {
    ExecutionMetrics.logger = originalLogger;
    ExecutionMetrics.colWidth = originalColWidth;
  });

  group('start/stop', () {
    test('returns a result with the task name', () {
      final metrics = ExecutionMetrics()..start(taskName: 'Test Task');
      final result = metrics.stop();

      expect(result.taskName, 'Test Task');
      expect(result.deviceInfo, isNull);
      expect(result.elapsed, greaterThanOrEqualTo(Duration.zero));
    });

    test('keeps device info', () {
      final metrics = ExecutionMetrics()
        ..start(taskName: 'Test Task', deviceInfo: 'Test Device');

      expect(metrics.stop().deviceInfo, 'Test Device');
    });

    test('measures elapsed time', () async {
      final metrics = ExecutionMetrics()..start(taskName: 'Delay');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(metrics.stop().totalMilliseconds, greaterThanOrEqualTo(45));
    });

    test('reusing an instance starts from zero', () async {
      final metrics = ExecutionMetrics()..start(taskName: 'First');
      await Future<void>.delayed(const Duration(milliseconds: 100));
      metrics.stop();

      metrics.start(taskName: 'Second');
      final second = metrics.stop();

      expect(second.taskName, 'Second');
      expect(second.totalMilliseconds, lessThan(100));
    });

    test('stop without start throws', () {
      expect(() => ExecutionMetrics().stop(), throwsStateError);
    });

    test('start twice throws', () {
      final metrics = ExecutionMetrics()..start(taskName: 'A');

      expect(() => metrics.start(taskName: 'B'), throwsStateError);
    });

    test('reports through the logger', () {
      (ExecutionMetrics()..start(taskName: 'Logged')).stop();

      expect(logs, hasLength(1));
      expect(logs.single, contains('Logged'));
    });

    test('a null logger disables the report', () {
      ExecutionMetrics.logger = null;
      final result = (ExecutionMetrics()..start(taskName: 'Silent')).stop();

      expect(result.taskName, 'Silent');
      expect(logs, isEmpty);
    });
  });

  group('run', () {
    test('executes the action and returns its value', () {
      var executed = false;
      final result = ExecutionMetrics.run(
        taskName: 'Run Task',
        action: () {
          executed = true;
          return 'success';
        },
      );

      expect(executed, isTrue);
      expect(result, 'success');
    });

    test('passes the TaskResult to the callback', () {
      TaskResult? captured;
      ExecutionMetrics.run(
        taskName: 'Callback Task',
        action: () {},
        callback: (result) => captured = result,
      );

      expect(captured?.taskName, 'Callback Task');
    });

    test('still reports when the action throws', () {
      TaskResult? captured;

      expect(
        () => ExecutionMetrics.run<void>(
          taskName: 'Failing',
          action: () => throw const FormatException('boom'),
          callback: (result) => captured = result,
        ),
        throwsFormatException,
      );
      expect(captured?.taskName, 'Failing');
      expect(logs, hasLength(1));
    });

    test('a failing callback does not hide the action error', () {
      expect(
        () => ExecutionMetrics.run<void>(
          taskName: 'Failing',
          action: () => throw const FormatException('boom'),
          callback: (_) => throw StateError('callback'),
        ),
        throwsFormatException,
      );
    });
  });

  group('runAsync', () {
    test('executes the action and returns its value', () async {
      var executed = false;
      final result = await ExecutionMetrics.runAsync(
        taskName: 'Run Async Task',
        action: () async {
          await Future<void>.delayed(const Duration(milliseconds: 10));
          executed = true;
          return 'async success';
        },
      );

      expect(executed, isTrue);
      expect(result, 'async success');
    });

    test('still reports when the action throws', () async {
      TaskResult? captured;

      await expectLater(
        ExecutionMetrics.runAsync<void>(
          taskName: 'Failing async',
          action: () async => throw const FormatException('boom'),
          callback: (result) => captured = result,
        ),
        throwsFormatException,
      );
      expect(captured?.taskName, 'Failing async');
    });
  });

  group('formatReport', () {
    const result = TaskResult(
      taskName: 'Task',
      elapsed: Duration(minutes: 1, seconds: 2, milliseconds: 3),
      deviceInfo: 'Device',
    );

    void expectAlignedBox(String report) {
      final widths = report.split('\n').map((line) => line.length).toSet();
      expect(widths, hasLength(1), reason: report);
    }

    test('draws an aligned box with the values', () {
      final report = ExecutionMetrics.formatReport(result);

      expectAlignedBox(report);
      expect(report, contains('Device'));
      expect(report, matches(RegExp(r'║\s+1\s+║\s+2\s+║\s+3\s+║')));
    });

    test('omits the device row when there is no device info', () {
      const noDevice = TaskResult(taskName: 'Task', elapsed: Duration.zero);

      expect(
          ExecutionMetrics.formatReport(noDevice).split('\n'),
          hasLength(
              ExecutionMetrics.formatReport(result).split('\n').length - 2));
    });

    test('truncates long task names', () {
      final longName = TaskResult(taskName: 'x' * 200, elapsed: Duration.zero);
      final report = ExecutionMetrics.formatReport(longName);

      expectAlignedBox(report);
      expect(report, contains('…'));
    });

    test('stays aligned with a custom or too small column width', () {
      for (final width in [30, 5]) {
        ExecutionMetrics.colWidth = width;
        expectAlignedBox(ExecutionMetrics.formatReport(result));
      }
    });
  });
}
