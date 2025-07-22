import 'package:flutter/material.dart';
import 'package:frontend/controllers/tasks_controller.dart';
import 'package:frontend/views/task_form.dart';
import 'package:get/get.dart';
import '../widgets/task_tile.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager'), centerTitle: true),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            controller.fetchTasks();
          },
          child: controller.tasks.isEmpty && !controller.isLoading.value
              ? const Center(
                  child: Text(
                    'No tasks found. Pull down to refresh or add a new task!',
                  ),
                )
              : ListView.builder(
                  itemCount: controller.tasks.length,
                  itemBuilder: (_, i) => TaskTile(task: controller.tasks[i]),
                ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const TaskFormScreen()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
