//lib/screens/task_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;

  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit screen
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              taskProvider.deleteTask(task.id!);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(task.description),
            SizedBox(height: 16),
            Text('Due Date: ${task.dueDate.toLocal()}'),
            SizedBox(height: 16),
            Text(task.isRepeated ? 'Repeated Task' : 'One-Time Task'),
          ],
        ),
      ),
    );
  }
}
