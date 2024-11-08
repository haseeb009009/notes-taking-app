//lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Task Management')),
      body: FutureBuilder(
        future: taskProvider.loadTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return TaskListWidget(tasks: taskProvider.tasks);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add task screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
