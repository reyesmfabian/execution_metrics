import 'dart:convert';

TaskResult taskResultFromJson(String str) =>
    TaskResult.fromJson(json.decode(str));

String taskResultToJson(TaskResult data) => json.encode(data.toJson());

class TaskResult {
  final String taskName;
  final String? deviceInfo;
  final int minutes;
  final int seconds;
  final int milliseconds;

  TaskResult({
    required this.taskName,
    required this.minutes,
    required this.seconds,
    required this.milliseconds,
    this.deviceInfo = '',
  });

  factory TaskResult.fromJson(Map<String, dynamic> json) => TaskResult(
        taskName: json["taskName"],
        minutes: json["minutes"],
        seconds: json["seconds"],
        milliseconds: json["milliseconds"],
        deviceInfo: json["deviceInfo"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "taskName": taskName,
        "minutes": minutes,
        "seconds": seconds,
        "milliseconds": milliseconds,
        "deviceInfo": deviceInfo,
      };
}
