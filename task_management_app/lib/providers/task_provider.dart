import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];
  ThemeMode _themeMode = ThemeMode.system;
  final DatabaseService _databaseService = DatabaseService();

  TaskProvider() {
    loadTasks(); // Load tasks each time TaskProvider is initialized
  }

  List<TaskModel> get tasks => _tasks;
  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // Loads tasks from the database and adds a default task if the list is empty
  Future<void> loadTasks() async {
    _tasks = await _databaseService.getTasks(); // Fetch tasks from database

    // Check if there are no tasks, add a default task if list is empty
    if (_tasks.isEmpty) {
      await _addDefaultTask(); // Add a default task
      _tasks = await _databaseService
          .getTasks(); // Reload tasks after adding the default
    }

    notifyListeners(); // Notify listeners that tasks have been updated
  }

  // Adds a default task for when the task list is empty
  Future<void> _addDefaultTask() async {
    TaskModel defaultTask = TaskModel(
      title: 'Welcome to Task Manager!',
      description: 'This is your first task. Edit or delete it as you like.',
      dueDate: DateTime.now().add(const Duration(days: 1)), // Due tomorrow
      isCompleted: false,
      isRepeated: false,
      subtasks: ['Get started', 'Explore features'],
      subtaskCompletion: [false, false],
    );

    addTask(defaultTask); // Add the default task
  }

  void addTask(TaskModel task) async {
    await _databaseService.insertTask(task); // Insert task into the database
    NotificationService().scheduleNotification(
      task.id!,
      "Task Reminder: ${task.title}",
      "Don't forget your task due on ${task.dueDate}",
      task.dueDate,
    );
    loadTasks(); // Reloads tasks
  }

  void updateTask(TaskModel task) async {
    await _databaseService.updateTask(task);
    NotificationService().cancelNotification(task.id!);
    NotificationService().scheduleNotification(
      task.id!,
      "Updated Task Reminder: ${task.title}",
      "Due on ${task.dueDate}",
      task.dueDate,
    );
    loadTasks();
  }

  void deleteTask(int id) async {
    await _databaseService.deleteTask(id);
    NotificationService().cancelNotification(id);
    loadTasks();
  }

  void toggleCompletion(TaskModel task) async {
    task.isCompleted = !task.isCompleted;
    await _databaseService.updateTask(task);
    loadTasks();
  }

  void toggleSubtaskCompletion(TaskModel task, int index) {
    task.subtaskCompletion[index] = !task.subtaskCompletion[index];
    notifyListeners();
  }

  void updateSubtasks(TaskModel task, List<String> newSubtasks,
      List<bool> newCompletionStatus) async {
    task.subtasks = newSubtasks;
    task.subtaskCompletion = newCompletionStatus;
    await _databaseService.updateTask(task);
    loadTasks();
  }

  double getTaskProgress(TaskModel task) {
    if (task.subtasks.isEmpty) return 0.0;
    final completed = task.subtaskCompletion.where((c) => c).length;
    return completed / task.subtasks.length;
  }

  List<TaskModel> get todayTasks =>
      _tasks.where((task) => task.dueDate == DateTime.now()).toList();

  List<TaskModel> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  List<TaskModel> get repeatedTasks =>
      _tasks.where((task) => task.isRepeated).toList();

  Future<void> exportToCSV() async {
    List<List<String>> rows = [
      ['ID', 'Title', 'Description', 'Due Date', 'Completed', 'Repeated']
    ];

    for (var task in _tasks) {
      rows.add([
        task.id.toString(),
        task.title,
        task.description,
        task.dueDate.toString(),
        task.isCompleted ? 'Yes' : 'No',
        task.isRepeated ? 'Yes' : 'No'
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/tasks.csv';
    final file = File(path);
    print("CSV Exported: $path");
    await file.writeAsString(csvData);
  }

  Future<void> exportToPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: _tasks.map((task) {
              return pw.Container(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Task: ${task.title}',
                        style: pw.TextStyle(
                            fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Description: ${task.description}'),
                    pw.Text('Due Date: ${task.dueDate.toLocal()}'),
                    pw.Text('Completed: ${task.isCompleted ? 'Yes' : 'No'}'),
                    pw.Text('Repeated: ${task.isRepeated ? 'Yes' : 'No'}'),
                    pw.Divider(),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/tasks.pdf';
    final file = File(path);
    print("PDF Exported: $path");
    await file.writeAsBytes(await pdf.save());
  }
}
