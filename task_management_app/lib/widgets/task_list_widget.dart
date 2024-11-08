//lib/widget/task_list_widget.dart

import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskListWidget extends StatelessWidget {
  final List<TaskModel> tasks;

  TaskListWidget({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Mark task as completed
            },
          ),
        );
      },
    );
  }
}
