import 'package:flutter/material.dart';
import 'package:frontend/controllers/tasks_form_controller.dart';
import 'package:get/get.dart';
import 'package:frontend/models/task.dart';
import 'package:frontend/models/worker.dart' as app_worker;

class TaskFormScreen extends StatelessWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    // We explicitly put the controller here.
    // Get.put ensures that if it's already there (e.g., if you navigate back),
    // it won't create a new one, but for this screen, it's typically new.
    final TaskFormController controller = Get.put(
      TaskFormController(taskToEdit: task),
    );

    // Determine the title based on whether a task is being edited.
    // This value is determined once when the screen is built.
    final String appBarTitle = controller.taskToEdit == null
        ? 'Add Task'
        : 'Edit Task';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle), // Directly use the determined title
      ),
      body: Obx(() {
        // Keep Obx for the body as it observes Rx variables
        if (controller.isLoading.value && controller.availableWorkers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: controller.titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: controller.validateTitle,
                ),
                TextFormField(
                  controller: controller.descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.status.value,
                    items: ['pending', 'active', 'completed']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: controller.setStatus,
                    decoration: const InputDecoration(labelText: 'Status'),
                  ),
                ),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.importance.value,
                    items: ['low', 'mid', 'high']
                        .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                        .toList(),
                    onChanged: controller.setImportance,
                    decoration: const InputDecoration(labelText: 'Importance'),
                  ),
                ),
                Obx(
                  () => DropdownButtonFormField<app_worker.Worker>(
                    value: controller.selectedWorker.value,
                    items: controller.availableWorkers
                        .map(
                          (w) => DropdownMenuItem<app_worker.Worker>(
                            value: w,
                            child: Text(w.name),
                          ),
                        )
                        .toList(),
                    onChanged: controller.setSelectedWorker,
                    decoration: const InputDecoration(
                      labelText: 'Assign Worker',
                    ),
                    hint: const Text('Select a worker'),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.submitForm,
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            appBarTitle == 'Add Task'
                                ? 'Create Task'
                                : 'Update Task', // Use appBarTitle here too
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
