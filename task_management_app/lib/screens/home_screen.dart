import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../screens/add_task_screen.dart';
import '../screens/task_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            tooltip: 'Export to CSV',
            onPressed: () async {
              await taskProvider.exportToCSV();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tasks exported to CSV')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            tooltip: 'Export to PDF',
            onPressed: () async {
              await taskProvider.exportToPDF();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tasks exported to PDF')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme',
            onPressed: () {
              // Toggle theme between light and dark
              final isDarkMode = Theme.of(context).brightness == Brightness.dark;
              taskProvider.setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddTaskScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final tasks = taskProvider.tasks;

          return tasks.isEmpty
              ? Center(child: Text('No tasks available'))
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      trailing: Icon(
                        task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                        color: task.isCompleted ? Colors.green : Colors.grey,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(task: task),
                          ),
                        );
                      },
                    );
                  },
                );
        },
      ),
    );
  }
}
