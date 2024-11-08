import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;

  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${task.title}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Description: ${task.description}'),
            SizedBox(height: 10),
            Text('Due Date: ${task.dueDate.toLocal()}'.split(' ')[0]),
            SizedBox(height: 10),
            Text('Completed: ${task.isCompleted ? 'Yes' : 'No'}'),
            SizedBox(height: 10),
            Text('Repeated: ${task.isRepeated ? 'Yes' : 'No'}'),
          ],
        ),
      ),
    );
  }
}
