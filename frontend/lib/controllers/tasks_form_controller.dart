import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/models/task.dart';
import 'package:frontend/models/worker.dart' as app_worker;
import 'package:frontend/controllers/tasks_controller.dart';
import 'package:frontend/services/api_service.dart';

class TaskFormController extends GetxController {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  final RxString status = 'pending'.obs;
  final RxString importance = 'mid'.obs;
  final Rx<app_worker.Worker?> selectedWorker = Rx<app_worker.Worker?>(null);
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  final TaskController _mainTaskController = Get.find<TaskController>();

  RxList<app_worker.Worker> availableWorkers = <app_worker.Worker>[].obs;

  final RxBool isLoading = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Task? taskToEdit;

  TaskFormController({this.taskToEdit});

  @override
  void onInit() {
    super.onInit();

    titleController = TextEditingController(text: taskToEdit?.title);
    descriptionController = TextEditingController(
      text: taskToEdit?.description,
    );

    status.value = taskToEdit?.status ?? 'pending';
    importance.value = taskToEdit?.importance ?? 'mid';
    selectedDate.value = taskToEdit?.dueDate;

    fetchWorkersForDropdown().then((_) {
      if (taskToEdit?.worker != null) {
        selectedWorker.value = availableWorkers.firstWhereOrNull(
          (worker) => worker.id == taskToEdit!.worker!.id,
        );
      }
    });
  }

  Future<void> fetchWorkersForDropdown() async {
    if (_mainTaskController.workers.isNotEmpty) {
      availableWorkers.assignAll(
        _mainTaskController.workers.cast<app_worker.Worker>(),
      );
    } else {
      try {
        isLoading(true);
        final fetchedWorkers = await ApiService.getWorkers();
        availableWorkers.assignAll(fetchedWorkers.cast<app_worker.Worker>());
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to load workers: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading(false);
      }
    }
  }

  void setStatus(String? value) {
    if (value != null) {
      status.value = value;
    }
  }

  void setImportance(String? value) {
    if (value != null) {
      importance.value = value;
    }
  }

  void setSelectedWorker(app_worker.Worker? worker) {
    selectedWorker.value = worker;
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          selectedDate.value ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  // Clear the selected date
  void clearDate() {
    selectedDate.value = null;
  }

  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  Future<void> submitForm() async {
    if (formKey.currentState!.validate()) {
      isLoading(true);
      try {
        final Map<String, dynamic> data = {
          'title': titleController.text,
          'description': descriptionController.text.isEmpty
              ? null
              : descriptionController.text,
          'status': status.value,
          'importance': importance.value,
          'worker_id': selectedWorker.value?.id,
          'due_date': selectedDate.value?.toIso8601String(),
        };

        if (taskToEdit == null) {
          await _mainTaskController.addTask(data);
          titleController.clear();
          descriptionController.clear();
          status.value = 'pending';
          importance.value = 'mid';
          selectedWorker.value = null;
          selectedDate.value = null;

          Get.back();
          Get.snackbar(
            'Success',
            'Task created successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          await _mainTaskController.updateTask(taskToEdit!.id, data);
          Get.back();
          Get.snackbar(
            'Success',
            'Task updated successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to save task: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading(false);
      }
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
