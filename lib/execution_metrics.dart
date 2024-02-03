// ignore_for_file: avoid_print

library execution_metrics;

import 'package:execution_metrics/mappers/task_result_mapper.dart';

class ExecutionMetrics {
  final Stopwatch _stopwatch = Stopwatch();
  String _taskName = "";

  void start({required String taskName}) {
    _taskName = taskName;
    _stopwatch.start();
  }

  TaskResult stop() {
    _stopwatch.stop();

    var minutes = _stopwatch.elapsed.inMinutes;
    var seconds = _stopwatch.elapsed.inSeconds % 60;
    var milliseconds = _stopwatch.elapsed.inMilliseconds % 1000;
    print('╔════════════════════════════════════════════════════════════════╗');
    print('║                        Execution Result                        ║');
    print('╠══════════════════════╦═════════╦══════════╦════════════════════╣');
    print('║ Task Name            ║ Minutes ║ Seconds  ║ Milliseconds       ║');
    print('╠══════════════════════╬═════════╬══════════╬════════════════════╣');
    print(
      '║ ${_taskName.padRight(20)} ║ '
      '${minutes.toString().padLeft(7)} ║ '
      '${seconds.toString().padLeft(8)} ║ '
      '${milliseconds.toString().padLeft(18)} ║',
    );
    print('╚══════════════════════╩═════════╩══════════╩════════════════════╝');

    return TaskResult(
      taskName: _taskName,
      minutes: _stopwatch.elapsed.inMinutes,
      seconds: _stopwatch.elapsed.inSeconds % 60,
      milliseconds: _stopwatch.elapsed.inMilliseconds % 1000,
    );
  }
}
