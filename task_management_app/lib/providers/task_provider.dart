//lib/providers/task_provider.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];
  final DatabaseService _databaseService = DatabaseService();

  TaskProvider() {
    loadTasks();
  }

  List<TaskModel> get tasks => _tasks;

  Future<void> loadTasks() async {
    // Fetch tasks from the database
    _tasks = await _databaseService.getTasks();
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    // Insert task into the database and reload tasks
    await _databaseService.insertTask(task);
    loadTasks();
  }

  Future<void> updateTask(TaskModel task) async {
    // Update task in the database and reload tasks
    await _databaseService.updateTask(task);
    loadTasks();
  }

  Future<void> deleteTask(int id) async {
    // Delete task from the database and reload tasks
    await _databaseService.deleteTask(id);
    loadTasks();
  }

  Future<void> toggleCompletion(TaskModel task) async {
    // Toggle completion status and update task in the database
    task.isCompleted = !task.isCompleted;
    await _databaseService.updateTask(task);
    loadTasks();
  }

  // Export to CSV
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

  // Export to PDF
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
    await file.writeAsBytes(await pdf.save());
    print("PDF Exported: $path");
  }
}
