import 'package:frontend/models/worker.dart';

class Task {
  final int id;
  final String title;
  final String? description;
  final String status;
  final String importance;
  final Worker? worker;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.importance,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'importance': importance,
      'worker_id': worker?.id,
    };
  }
}
