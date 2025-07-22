import 'package:flutter/material.dart';
import 'package:frontend/controllers/tasks_controller.dart';
import 'package:frontend/views/task_form.dart';
import 'package:get/get.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red.shade700,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(Icons.delete, color: Colors.white, size: 36.0),
      ),

      onDismissed: (direction) {
        Get.snackbar(
          'Task Deleted',
          '${task.title} was removed.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          mainButton: TextButton(
            onPressed: () {
              if (Get.isSnackbarOpen) {
                Get.back();
              }
            },
            child: const Text(
              'UNDO',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        );
        controller.deleteTask(task.id);
      },

      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          title: Text(task.title),
          subtitle: Text(
            '${task.status.toUpperCase()} • ${task.importance.toUpperCase()}\n${task.worker?.name ?? 'Unassigned'}',
          ),
          isThreeLine: true,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Get.to(() => TaskFormScreen(task: task)),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: Text(
                        'Are you sure you want to delete "${task.title}"?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.deleteTask(task.id);
                            Get.back(); // Close dialog
                            Get.snackbar(
                              'Task Deleted',
                              '${task.title} was permanently removed.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.black87,
                              colorText: Colors.white,
                            );
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
