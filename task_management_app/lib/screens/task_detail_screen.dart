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
            Text('Description:', style: TextStyle(fontSize: 18)),
            Text(task.description),
            SizedBox(height: 16),
            Text('Due Date: ${task.dueDate.toLocal()}'),
            SizedBox(height: 16),
            Text('Subtasks:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: task.subtasks.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(task.subtasks[index]),
                    value: task.subtaskCompletion[index],
                    onChanged: (value) {
                      taskProvider.toggleSubtaskCompletion(task, index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(task.isCompleted ? Icons.check : Icons.close),
        onPressed: () {
          taskProvider.toggleCompletion(task);
        },
      ),
    );
  }
}
