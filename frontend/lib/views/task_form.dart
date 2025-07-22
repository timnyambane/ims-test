import 'package:flutter/material.dart';
import 'package:frontend/controllers/tasks_form_controller.dart';
import 'package:get/get.dart';
import 'package:frontend/models/task.dart';
import 'package:frontend/models/worker.dart' as app_worker;
import 'package:intl/intl.dart';

class TaskFormScreen extends StatelessWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    final TaskFormController controller = Get.put(
      TaskFormController(taskToEdit: task),
    );

    final String appBarTitle = controller.taskToEdit == null
        ? 'Add Task'
        : 'Edit Task';

    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      body: Obx(() {
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
                // New: Due Date Picker
                GestureDetector(
                  onTap: () => controller.pickDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(
                        text: controller.selectedDate.value == null
                            ? ''
                            : DateFormat(
                                'dd/MM/yyyy',
                              ).format(controller.selectedDate.value!),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Due Date',
                        suffixIcon: controller.selectedDate.value != null
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: controller.clearDate,
                              )
                            : const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                                : 'Update Task',
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
