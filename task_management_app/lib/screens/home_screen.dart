import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../add_task_screen.dart';
import '../screens/task_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            tooltip: 'Export to CSV',
            onPressed: () async {
              await taskProvider.exportToCSV();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tasks exported to CSV')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export to PDF',
            onPressed: () async {
              await taskProvider.exportToPDF();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tasks exported to PDF')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme',
            onPressed: () {
              final isDarkMode =
                  Theme.of(context).brightness == Brightness.dark;
              taskProvider
                  .setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Toggle Theme',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddTaskScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Content above the buttons (tasks list or other widgets)
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                final tasks = taskProvider.tasks;
                return tasks.isEmpty
                    ? const Center(child: Text('No tasks available'))
                    : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return ListTile(
                            title: Text(task.title),
                            subtitle: Text(task.description),
                            trailing: Icon(
                              task.isCompleted
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color:
                                  task.isCompleted ? Colors.green : Colors.grey,
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TaskDetailScreen(task: task),
                                ),
                              );
                            },
                          );
                        },
                      );
              },
            ),
          ),

          // Buttons positioned at the bottom of the screen
          Padding(
            padding:
                const EdgeInsets.all(16.0), // Adds padding around the buttons
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center the buttons horizontally
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('TODAY Task'),
                ),
                const SizedBox(height: 20), // Adds space between buttons
                ElevatedButton(
                  onPressed: () {
                    // Add action for the second button
                    print('COMPLETED  Task');
                  },
                  child: const Text('COMPLETED  Task'),
                ),
                const SizedBox(height: 20), // Adds space between buttons
                ElevatedButton(
                  onPressed: () {
                    // Add action for the third button
                    print('Button 3 Pressed');
                  },
                  child: const Text('REPEATED  Task'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
