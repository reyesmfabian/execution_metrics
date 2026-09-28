import 'dart:convert';

/// Decodes a [TaskResult] from a JSON string.
TaskResult taskResultFromJson(String str) =>
    TaskResult.fromJson(json.decode(str) as Map<String, dynamic>);

/// Encodes a [TaskResult] as a JSON string.
String taskResultToJson(TaskResult data) => json.encode(data.toJson());

/// The outcome of a measured task.
class TaskResult {
  /// Creates a result for [taskName] that took [elapsed].
  const TaskResult({
    required this.taskName,
    required this.elapsed,
    this.deviceInfo,
  });

  /// Builds a [TaskResult] from its JSON representation.
  ///
  /// Accepts both the current format (with `elapsedMicroseconds`) and the
  /// legacy one that only carried `minutes`, `seconds` and `milliseconds`.
  factory TaskResult.fromJson(Map<String, dynamic> json) {
    final micros = json['elapsedMicroseconds'] as int?;
    return TaskResult(
      taskName: json['taskName'] as String,
      elapsed: micros != null
          ? Duration(microseconds: micros)
          : Duration(
              minutes: json['minutes'] as int? ?? 0,
              seconds: json['seconds'] as int? ?? 0,
              milliseconds: json['milliseconds'] as int? ?? 0,
            ),
      deviceInfo: json['deviceInfo'] as String?,
    );
  }

  /// Name given to the task when it was measured.
  final String taskName;

  /// Total time the task took.
  final Duration elapsed;

  /// Optional device description (model, OS, ...).
  final String? deviceInfo;

  /// Whole minutes of [elapsed].
  int get minutes => elapsed.inMinutes;

  /// Seconds component of [elapsed] (0-59). Use [elapsed] for the total.
  int get seconds => elapsed.inSeconds.remainder(60);

  /// Milliseconds component of [elapsed] (0-999). Use [totalMilliseconds]
  /// for the total.
  int get milliseconds => elapsed.inMilliseconds.remainder(1000);

  /// Total time the task took, in milliseconds.
  int get totalMilliseconds => elapsed.inMilliseconds;

  /// JSON representation. `deviceInfo` is omitted when it is `null`.
  Map<String, dynamic> toJson() => {
        'taskName': taskName,
        'elapsedMicroseconds': elapsed.inMicroseconds,
        'minutes': minutes,
        'seconds': seconds,
        'milliseconds': milliseconds,
        if (deviceInfo != null) 'deviceInfo': deviceInfo,
      };

  @override
  bool operator ==(Object other) =>
      other is TaskResult &&
      other.taskName == taskName &&
      other.elapsed == elapsed &&
      other.deviceInfo == deviceInfo;

  @override
  int get hashCode => Object.hash(taskName, elapsed, deviceInfo);

  @override
  String toString() => 'TaskResult(taskName: $taskName, elapsed: $elapsed'
      '${deviceInfo != null ? ', deviceInfo: $deviceInfo' : ''})';
}
