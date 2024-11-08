import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];
  ThemeMode _themeMode = ThemeMode.system; // ThemeMode variable to manage theme

  final DatabaseService _databaseService = DatabaseService();

  TaskProvider() {
    loadTasks();
  }

  List<TaskModel> get tasks => _tasks;
  ThemeMode get themeMode => _themeMode; // Getter for ThemeMode

  // Method to set and toggle the theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // Method to load tasks from the database
  Future<void> loadTasks() async {
    _tasks = await _databaseService.getTasks();
    notifyListeners();
  }

  // Method to add a task with notification and refresh the list
  void addTask(TaskModel task) async {
    await _databaseService.insertTask(task);
    NotificationService().scheduleNotification(
      task.id!,
      "Task Reminder: ${task.title}",
      "Don't forget your task due on ${task.dueDate}",
      task.dueDate,
    );
    loadTasks();
  }

  // Method to update a task, reschedule notification, and refresh the list
  void updateTask(TaskModel task) async {
    await _databaseService.updateTask(task);
    NotificationService().cancelNotification(task.id!); // Cancel old notification
    NotificationService().scheduleNotification(
      task.id!,
      "Updated Task Reminder: ${task.title}",
      "Due on ${task.dueDate}",
      task.dueDate,
    );
    loadTasks();
  }

  // Method to delete a task and refresh the list
  void deleteTask(int id) async {
    await _databaseService.deleteTask(id);
    NotificationService().cancelNotification(id); // Cancel notification on delete
    loadTasks();
  }

  // Method to toggle task completion status and refresh the list
  void toggleCompletion(TaskModel task) async {
    task.isCompleted = !task.isCompleted;
    await _databaseService.updateTask(task);
    loadTasks();
  }

  // Method to toggle a subtask's completion status
  void toggleSubtaskCompletion(TaskModel task, int index) {
    task.subtaskCompletion[index] = !task.subtaskCompletion[index];
    notifyListeners();
  }

  // Method to update subtasks and their completion statuses
  void updateSubtasks(TaskModel task, List<String> newSubtasks, List<bool> newCompletionStatus) async {
    task.subtasks = newSubtasks;
    task.subtaskCompletion = newCompletionStatus;
    await _databaseService.updateTask(task);
    loadTasks(); // Refresh the task list
  }

  // Method to calculate task progress based on completed subtasks
  double getTaskProgress(TaskModel task) {
    if (task.subtasks.isEmpty) return 0.0;
    final completed = task.subtaskCompletion.where((c) => c).length;
    return completed / task.subtasks.length;
  }

  // Filtered task lists
  List<TaskModel> get todayTasks => _tasks.where((task) => task.dueDate == DateTime.now()).toList();
  List<TaskModel> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  List<TaskModel> get repeatedTasks => _tasks.where((task) => task.isRepeated).toList();

  // Export tasks to CSV format
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
    await file.writeAsString(csvData);
    print("CSV Exported: $path");
  }

  // Export tasks to PDF format
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
                    pw.Text('Task: ${task.title}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Description: ${task.description}'),
                    pw.Text('Due Date: ${task.dueDate.toLocal()}'),
                    pw.Text('Completed: ${task.isCompleted ? 'Yes' : 'No'}'),
                    pw.Text('Repeated: ${task.isRepeated ? 'Yes' : 'No'}),
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
    await file.writeAsBytes(await pdf.save());
    print("PDF Exported: $path");
  }
}
