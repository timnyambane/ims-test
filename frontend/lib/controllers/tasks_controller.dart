import 'package:get/get.dart';
import '../models/task.dart';
import '../models/worker.dart' as app_worker;
import '../services/api_service.dart';
import 'package:flutter/material.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var workers = <app_worker.Worker>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
    fetchWorkers();
  }

  Future<void> fetchTasks() async {
    try {
      isLoading(true);
      errorMessage('');

      final fetchedTasks = await ApiService.getTasks();
      tasks.assignAll(fetchedTasks);
      sortTasks();
    } catch (e) {
      errorMessage('Failed to load tasks: $e');
      Get.snackbar(
        'Error',
        'Failed to load tasks. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> addTask(Map<String, dynamic> payload) async {
    try {
      final newTask = await ApiService.createTask(payload);
      tasks.add(newTask);
      sortTasks();
      Get.snackbar(
        'Success',
        'Task added!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add task: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<void> updateTask(int id, Map<String, dynamic> payload) async {
    try {
      final updatedTask = await ApiService.updateTask(id, payload);
      final index = tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        tasks[index] = updatedTask;
      }
      sortTasks();
      Get.snackbar(
        'Success',
        'Task updated!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update task: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<void> fetchWorkers() async {
    try {
      isLoading(true);
      final fetchedWorkers = await ApiService.getWorkers();
      workers.assignAll(fetchedWorkers.cast<app_worker.Worker>());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load workers for dropdown.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  void deleteTask(int id) async {
    try {
      await ApiService.deleteTask(id);
      tasks.removeWhere((t) => t.id == id);
      Get.snackbar(
        'Success',
        'Task deleted successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete task: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void removeTaskTemporarily(Task taskToRemove) {
    final int originalIndex = tasks.indexOf(taskToRemove);
    if (originalIndex != -1) {
      tasks.removeAt(originalIndex);
    }
  }

  void reinsertTask(Task taskToReinsert, int originalIndex) {
    if (originalIndex >= 0 && originalIndex <= tasks.length) {
      tasks.insert(originalIndex, taskToReinsert);
    } else {
      tasks.add(taskToReinsert);
    }
    sortTasks(); // Sort tasks after reinserting
  }

  Future<void> commitDeletion(int taskId) async {
    await ApiService.deleteTask(taskId);
  }

  int _getImportanceValue(String importance) {
    switch (importance.toLowerCase()) {
      case 'high':
        return 3;
      case 'mid':
        return 2;
      case 'low':
        return 1;
      default:
        return 0;
    }
  }

  void sortTasks() {
    tasks.sort((a, b) {
      int importanceA = _getImportanceValue(a.importance);
      int importanceB = _getImportanceValue(b.importance);
      return importanceB.compareTo(importanceA);
    });
  }
}
