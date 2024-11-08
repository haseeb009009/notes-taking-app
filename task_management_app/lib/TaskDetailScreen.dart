import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${task.description}'),
            const SizedBox(height: 10),
            Text('Due Date: ${task.dueDate.toLocal()}'),
            const SizedBox(height: 10),
            const Text('Subtasks:'),
            ...task.subtasks.asMap().entries.map((entry) {
              int idx = entry.key;
              String subtask = entry.value;

              return CheckboxListTile(
                title: Text(subtask),
                value: task.subtaskCompletion[idx],
                onChanged: (value) {
                  if (value != null) {
                    context.read<TaskProvider>().toggleSubtaskCompletion(task, idx);
                  }
                },
              );
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<TaskProvider>().deleteTask(task.id!);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Delete Task'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank),
        onPressed: () {
          context.read<TaskProvider>().toggleCompletion(task);
        },
      ),
    );
  }
}
