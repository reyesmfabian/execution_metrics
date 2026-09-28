import 'task_result.dart';

/// Receives the formatted report printed when a measurement stops.
typedef ExecutionLogger = void Function(String message);

// ignore: avoid_print
void _defaultLogger(String message) => print(message);

/// Measures how long a task takes and reports it.
class ExecutionMetrics {
  /// Width of each column (minutes / seconds / milliseconds) in the report.
  ///
  /// Values smaller than [minColWidth] are clamped.
  static int colWidth = 22;

  /// Smallest usable [colWidth]: fits the `Milliseconds` header plus padding.
  static const int minColWidth = 14;

  /// Inner width of the report box, derived from [colWidth].
  static int get boxContentWidth => _colWidth * 3 + 2;

  /// Where the report goes. Defaults to `print`; set to `null` to disable
  /// the report (callbacks and return values still work).
  static ExecutionLogger? logger = _defaultLogger;

  static int get _colWidth => colWidth < minColWidth ? minColWidth : colWidth;

  final Stopwatch _stopwatch = Stopwatch();
  String _taskName = '';
  String? _deviceInfo;
  void Function(TaskResult)? _callback;

  /// Whether a measurement is in progress.
  bool get isRunning => _stopwatch.isRunning;

  /// Starts measuring [taskName].
  ///
  /// The instance can be reused after [stop]; each call starts from zero.
  /// Throws a [StateError] if a measurement is already in progress.
  void start({
    required String taskName,
    String? deviceInfo,
    void Function(TaskResult)? callback,
  }) {
    if (isRunning) {
      throw StateError('Measurement "$_taskName" is already running.');
    }
    _taskName = taskName;
    _deviceInfo = deviceInfo;
    _callback = callback;
    _stopwatch
      ..reset()
      ..start();
  }

  /// Stops the measurement, reports it and returns the [TaskResult].
  ///
  /// Throws a [StateError] if [start] was not called first.
  TaskResult stop() {
    if (!isRunning) {
      throw StateError('stop() called without a matching start().');
    }
    _stopwatch.stop();

    final result = TaskResult(
      taskName: _taskName,
      elapsed: _stopwatch.elapsed,
      deviceInfo: _deviceInfo,
    );

    logger?.call(formatReport(result));
    _callback?.call(result);

    return result;
  }

  /// Measures the synchronous [action] and returns its value.
  ///
  /// If [action] throws, its error is rethrown unchanged, even if the report
  /// or [callback] fail as well.
  static T run<T>({
    required String taskName,
    required T Function() action,
    String? deviceInfo,
    void Function(TaskResult)? callback,
  }) {
    final metrics = ExecutionMetrics()
      ..start(taskName: taskName, deviceInfo: deviceInfo, callback: callback);
    final T value;
    try {
      value = action();
    } catch (_) {
      metrics._stopQuietly();
      rethrow;
    }
    metrics.stop();
    return value;
  }

  /// Measures the asynchronous [action] and returns its value.
  ///
  /// If [action] throws, its error is rethrown unchanged, even if the report
  /// or [callback] fail as well.
  static Future<T> runAsync<T>({
    required String taskName,
    required Future<T> Function() action,
    String? deviceInfo,
    void Function(TaskResult)? callback,
  }) async {
    final metrics = ExecutionMetrics()
      ..start(taskName: taskName, deviceInfo: deviceInfo, callback: callback);
    final T value;
    try {
      value = await action();
    } catch (_) {
      metrics._stopQuietly();
      rethrow;
    }
    metrics.stop();
    return value;
  }

  /// Stops without letting a failing logger/callback hide the original error.
  void _stopQuietly() {
    try {
      stop();
    } catch (_) {}
  }

  /// Builds the boxed report printed by [stop].
  static String formatReport(TaskResult result) {
    final col = _colWidth;
    final box = boxContentWidth;
    String row(String text) => '║ ${_center(text, box - 2)} ║';
    String cells(List<String> values) =>
        '║${values.map((v) => ' ${_center(v, col - 2)} ').join('║')}║';
    final separator = '╠${'═' * box}╣';

    return [
      '╔${'═' * box}╗',
      row('Execution Result'),
      separator,
      row(result.taskName),
      if (result.deviceInfo != null) ...[separator, row(result.deviceInfo!)],
      '╠${'═' * col}╦${'═' * col}╦${'═' * col}╣',
      cells(['Minutes', 'Seconds', 'Milliseconds']),
      '╠${'═' * col}╬${'═' * col}╬${'═' * col}╣',
      cells([
        '${result.minutes}',
        '${result.seconds}',
        '${result.milliseconds}',
      ]),
      '╚${'═' * col}╩${'═' * col}╩${'═' * col}╝',
    ].join('\n');
  }

  /// Centers [text] in [width] characters, truncating it with `…` if needed.
  static String _center(String text, int width) {
    if (text.length > width) return '${text.substring(0, width - 1)}…';
    final padLeft = (width - text.length) ~/ 2;
    return text.padLeft(text.length + padLeft).padRight(width);
  }
}
