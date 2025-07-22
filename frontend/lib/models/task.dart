import 'package:frontend/models/worker.dart';

class Task {
  final int id;
  final String title;
  final String? description;
  final String status;
  final String importance;
  final DateTime? dueDate;
  final Worker? worker;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.importance,
    this.dueDate,
    this.worker,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      importance: json['importance'],
      worker: json['worker'] != null ? Worker.fromJson(json['worker']) : null,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'importance': importance,
      'worker_id': worker?.id,
      'due_date': dueDate?.toIso8601String(),
    };
  }
}
