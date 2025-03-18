// ignore_for_file: avoid_print

library execution_metrics;

import 'package:execution_metrics/mappers/task_result_mapper.dart';

class ExecutionMetrics {
  final Stopwatch _stopwatch = Stopwatch();
  String _taskName = "";
  String? _deviceInfo = "";

  void start({required String taskName, String? deviceInfo}) {
    _taskName = taskName;
    _deviceInfo = deviceInfo;
    _stopwatch.start();
  }

  TaskResult stop() {
    _stopwatch.stop();

    var minutes = _stopwatch.elapsed.inMinutes;
    var seconds = _stopwatch.elapsed.inSeconds % 60;
    var milliseconds = _stopwatch.elapsed.inMilliseconds % 1000;
    const int boxContentWidth = 68;

    print('╔${'═' * boxContentWidth}╗');
    print('║${centerText('Execution Result', boxContentWidth)}║');
    print('╠${'═' * boxContentWidth}╣');

    print('║${centerText(_taskName, boxContentWidth)}║');

    if (_deviceInfo != null) {
      print('╠${'═' * boxContentWidth}╣');

      print('║${centerText(_deviceInfo ?? '', boxContentWidth)}║');
    }

    const int colWidth = 22;

    print('╠${'═' * colWidth}╦${'═' * colWidth}╦${'═' * colWidth}╣');

    print(
        '║ ${centerText('Minutes', colWidth - 2)} ║ ${centerText('Seconds', colWidth - 2)} ║ ${centerText('Milliseconds', colWidth - 2)} ║');

    print('╠${'═' * colWidth}╬${'═' * colWidth}╬${'═' * colWidth}╣');

    print(
        '║ ${centerText(minutes.toString(), colWidth - 2)} ║ ${centerText(seconds.toString(), colWidth - 2)} ║ ${centerText(milliseconds.toString(), colWidth - 2)} ║');
    print('╚${'═' * colWidth}╩${'═' * colWidth}╩${'═' * colWidth}╝');

    return TaskResult(
      taskName: _taskName,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      deviceInfo: _deviceInfo,
    );
  }

  // Función auxiliar para centrar texto en un ancho dado
  String centerText(String text, int width) {
    if (text.length >= width) return text;
    int totalPadding = width - text.length;
    int padLeft = totalPadding ~/ 2;
    int padRight = totalPadding - padLeft;
    return '${' ' * padLeft}$text${' ' * padRight}';
  }
}
