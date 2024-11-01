// lib/widgets/task_list_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';

class TaskListWidget extends StatelessWidget {
  final String filter;

  const TaskListWidget({Key? key, required this.filter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final List<Task> filteredTasks;

    // Filter tasks based on the filter value
    if (filter == 'today') {
      filteredTasks = taskProvider.tasks.where((task) =>
          task.dueDate.day == DateTime.now().day &&
          !task.isCompleted).toList();
    } else if (filter == 'completed') {
      filteredTasks = taskProvider.tasks.where((task) => task.isCompleted).toList();
    } else {
      filteredTasks = taskProvider.tasks.where((task) => task.isRepeated).toList();
    }

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: IconButton(
            icon: Icon(
              task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
              color: task.isCompleted ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              taskProvider.updateTask(
                task.copyWith(isCompleted: !task.isCompleted),
              );
            },
          ),
        );
      },
    );
  }
}
