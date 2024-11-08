// lib/widgets/task_list_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';
import '../screens/task_detail_screen.dart';

class TaskListWidget extends StatelessWidget {
  final String filter;
  final String searchQuery;
  final String sortOption;

  const TaskListWidget({
    super.key,
    required this.filter,
    this.searchQuery = "",
    this.sortOption = "none",
  });
  
  get filteredTasks => null;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    // Filter tasks based on the selected filter (today, completed, repeated)
   List<Task> sortedTasks = [...filteredTasks];
if (sortOption == 'date') {
  sortedTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
} else if (sortOption == 'title') {
  sortedTasks.sort((a, b) => a.title.compareTo(b.title));
}

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
            child: ListTile(
              title: Text(
                task.title,
                style: TextStyle(
                  color: task.isCompleted
                      ? Colors.grey
                      : Theme.of(context).textTheme.bodyLarge!.color,
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(task.description),
              trailing: IconButton(
                icon: Icon(
                  task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                  color: task.isCompleted ? Colors.green : Colors.grey,
                ),
                onPressed: () {
                  try {
                    taskProvider
                        .toggleTaskCompletion(task); // Toggle task complete
                  } catch (e) {
                    print("Error toggling task completion: $e");
                  }
                },
              ),
              onTap: () {
                try {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailScreen(task: task),
                    ),
                  );
                } catch (e) {
                  print("Error navigating to TaskDetailScreen: $e");
                }
              },
            ),
          ),
        );
      },
    );
  }
}
