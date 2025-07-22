import 'package:flutter/material.dart';
import 'package:frontend/controllers/tasks_controller.dart';
import 'package:frontend/views/task_form.dart';
import 'package:get/get.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();

    final int originalTaskIndex = controller.tasks.indexOf(task);

    final bool isHighImportance = task.importance.toLowerCase() == 'high';

    bool isOverdue = false;
    bool isDueSoon = false;
    String dueDateText = '';

    if (task.dueDate != null) {
      final now = DateTime.now();
      // Ensure we compare dates only, ignoring time for overdue/due soon logic
      final today = DateTime(now.year, now.month, now.day);
      final taskDueDate = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
      );

      if (taskDueDate.isBefore(today)) {
        isOverdue = true;
      }
      // Check if due today or tomorrow
      else if (taskDueDate.isAtSameMomentAs(today) ||
          taskDueDate.isAtSameMomentAs(today.add(const Duration(days: 1)))) {
        isDueSoon = true;
      }

      dueDateText = DateFormat('MMM dd, yyyy').format(task.dueDate!);
    }

    // Determine the level of highlight:
    // 1. Critical: High importance + Overdue
    // 2. Urgent: High importance + Due Soon
    // 3. Important: Just High importance
    // 4. Normal: Mid/Low importance
    final bool isCriticalHighlight = isHighImportance && isOverdue;
    final bool isUrgentHighlight =
        isHighImportance &&
        isDueSoon &&
        !isOverdue; // Not critical, but due soon
    final bool isGeneralHighHighlight =
        isHighImportance && !isCriticalHighlight && !isUrgentHighlight;

    // --- Define new color scheme for importance ---
    final Color highImportanceColor =
        Colors.orange.shade800; // Strong but not error red
    final Color highImportanceAccent =
        Colors.orange.shade100; // Light background for importance
    final Color criticalColor =
        Colors.red.shade700; // Keep some red for overdue high tasks
    final Color criticalAccent =
        Colors.red.shade50; // Light red for overdue background
    final Color dueSoonColor =
        Colors.blue.shade700; // Blue for tasks due very soon
    final Color dueSoonAccent = Colors.blue.shade50; // Light blue background

    Color cardColor;
    Color borderColor;
    IconData leadingIcon;
    Color iconColor;
    TextStyle titleStyle;
    TextStyle subtitleStyle;
    TextStyle dueDateStyle;

    if (isCriticalHighlight) {
      cardColor = criticalAccent;
      borderColor = criticalColor;
      leadingIcon = Icons.error_outline; // Changed from dangerous
      iconColor = criticalColor;
      titleStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: criticalColor,
        fontSize: 17,
      );
      subtitleStyle = TextStyle(color: criticalColor);
      dueDateStyle = TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: criticalColor,
      );
    } else if (isUrgentHighlight) {
      cardColor = dueSoonAccent;
      borderColor = dueSoonColor;
      leadingIcon = Icons.watch_later_outlined; // Clock icon for urgent
      iconColor = dueSoonColor;
      titleStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: dueSoonColor,
        fontSize: 17,
      );
      subtitleStyle = TextStyle(color: dueSoonColor);
      dueDateStyle = TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: dueSoonColor,
      );
    } else if (isGeneralHighHighlight) {
      cardColor = highImportanceAccent;
      borderColor = highImportanceColor;
      leadingIcon = Icons.star; // Star icon for general high importance
      iconColor = highImportanceColor;
      titleStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: highImportanceColor,
        fontSize: 17,
      );
      subtitleStyle = TextStyle(color: highImportanceColor.withOpacity(0.8));
      dueDateStyle = TextStyle(
        fontSize: 12,
        color: Colors.grey[600],
      ); // Normal gray for due date
    } else {
      // Default styles for mid/low importance
      cardColor = Theme.of(context).cardColor; // Default card color
      borderColor = Colors.transparent;
      leadingIcon = Icons.task; // Generic task icon or null
      iconColor = Colors.grey;
      titleStyle = Theme.of(context).textTheme.titleMedium!;
      subtitleStyle = Theme.of(context).textTheme.bodySmall!;
      dueDateStyle = TextStyle(fontSize: 12, color: Colors.grey[600]);
    }

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
        controller.removeTaskTemporarily(task);

        bool undoWasPressed = false;

        Get.snackbar(
          'Task Deleted',
          '${task.title} was removed.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          mainButton: TextButton(
            onPressed: () {
              undoWasPressed = true;
              if (Get.isSnackbarOpen) {
                Get.back();
              }
              controller.reinsertTask(task, originalTaskIndex);
              Get.snackbar(
                'Undo Successful',
                '${task.title} has been restored.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text(
              'UNDO',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );

        Future.delayed(const Duration(seconds: 3, milliseconds: 500), () {
          if (!undoWasPressed && !controller.tasks.contains(task)) {
            controller.commitDeletion(task.id);
          }
        });
      },
      child: Card(
        color: cardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: borderColor, width: isHighImportance ? 2 : 0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          leading: isHighImportance
              ? Icon(leadingIcon, color: iconColor, size: 30)
              : null,
          title: Text(task.title, style: titleStyle),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${task.status.toUpperCase()} • ${task.importance.toUpperCase()}\n${task.worker?.name ?? 'Unassigned'}',
                style: subtitleStyle,
              ),
              if (task.dueDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text('Due: $dueDateText', style: dueDateStyle),
                ),
            ],
          ),
          isThreeLine: task.dueDate != null,
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
                            Get.back();
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
