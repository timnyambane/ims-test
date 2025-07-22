import 'package:flutter/material.dart';
import 'package:frontend/controllers/tasks_controller.dart';
import 'package:frontend/views/task_list_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TaskController());
    return GetMaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const TaskListScreen(),
    );
  }
}
