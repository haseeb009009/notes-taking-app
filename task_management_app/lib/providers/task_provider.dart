// lib/providers/task_provider.dart

import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final DatabaseService _dbService = DatabaseService();

  List<Task> get tasks => _tasks;

  TaskProvider() {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    _tasks = await _dbService.fetchTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _dbService.insertTask(task);
    _tasks.add(task);
    notifyListeners();

    // Schedule notification if the due date is in the future
    if (task.dueDate.isAfter(DateTime.now())) {
      await NotificationService.showNotification(
        id: task.id ?? 0,
        title: 'Task Reminder',
        body: 'Don\'t forget your task: ${task.title}',
        scheduledDate: task.dueDate,
      );
    }
  }

  Future<void> updateTask(Task task) async {
    await _dbService.updateTask(task);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    await _dbService.deleteTask(id);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
