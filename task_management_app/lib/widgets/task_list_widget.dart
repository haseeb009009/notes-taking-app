// lib/widgets/task_list_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';
import '../screens/task_detail_screen.dart'; // Import TaskDetailScreen

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

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    List<Task> filteredTasks = taskProvider.tasks.where((task) {
      bool matchesFilter = filter == 'today'
          ? task.dueDate.day == DateTime.now().day && !task.isCompleted
          : filter == 'completed'
              ? task.isCompleted
              : task.isRepeated;

      bool matchesSearch = searchQuery.isEmpty ||
          task.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();

    // Sort tasks based on sortOption
    if (sortOption == 'date') {
      filteredTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else if (sortOption == 'title') {
      filteredTasks.sort((a, b) => a.title.compareTo(b.title));
    }

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailScreen(task: task),
              ),
            );
          },
          child: ListTile(
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
          ),
        );
      },
    );
  }
}
