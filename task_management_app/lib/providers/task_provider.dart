// lib/providers/task_provider.dart

import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final DatabaseService _dbService = DatabaseService();

  List<Task> get tasks => _tasks;

  TaskProvider() {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    _tasks = await _dbService.fetchTasks();
    print('Tasks after fetching: $_tasks');
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final taskId = await _dbService.insertTask(task);
    final newTask = task.copyWith(id: taskId);
    _tasks.add(newTask);
    print('Tasks after adding: $_tasks');
    notifyListeners();
  }

  // Toggle task completion status and print any errors
  Future<void> toggleTaskCompletion(Task task) async {
    try {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await updateTask(updatedTask);
    } catch (e) {
      print("Error in toggleTaskCompletion: $e");
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
}
