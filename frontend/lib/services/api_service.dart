import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';
import '../models/worker.dart';

class ApiService {
  static const baseUrl = 'http://127.0.0.1:8001/api';

  static Future<List<Task>> getTasks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tasks'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Task.fromJson(e)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(
          'Failed to load tasks: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to the API or unknown error');
    }
  }

  static Future<List<Worker>> getWorkers() async {
    final response = await http.get(Uri.parse('$baseUrl/workers'));
    final List data = jsonDecode(response.body);
    return data.map((e) => Worker.fromJson(e)).toList();
  }

  static Future<Task> createTask(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    return Task.fromJson(jsonDecode(response.body));
  }

  static Future<Task> updateTask(int id, Map<String, dynamic> payload) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    return Task.fromJson(jsonDecode(response.body));
  }

  static Future<void> deleteTask(int id) async {
    await http.delete(Uri.parse('$baseUrl/tasks/$id'));
  }
}
