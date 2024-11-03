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

  // Fetch all tasks from the database
  Future<void> fetchTasks() async {
    _tasks = await _dbService.fetchTasks();
    notifyListeners();
  }

  // Add a new task to the database and to the local task list
  Future<void> addTask(Task task) async {
    final taskId = await _dbService.insertTask(task);
    final newTask = task.copyWith(id: taskId);
    _tasks.add(newTask);
    notifyListeners();
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    // Update the task in the database
    await _dbService.updateTask(task);

    // Find the index of the task to update in the local list
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      // Update the task in the local list
      _tasks[index] = task;
      notifyListeners(); // Notify listeners to refresh UI
    }
  }

  // Add a new subtask to a specific task
  Future<void> addSubtask(Task task, Subtask subtask) async {
    final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
    if (taskIndex != -1) {
      final newSubtaskId = await _dbService.insertSubtask(task.id!, subtask);
      final newSubtask = subtask.copyWith(id: newSubtaskId);
      _tasks[taskIndex].subtasks.add(newSubtask);
      notifyListeners();
    }
  }

  // Update an existing subtask within a task
  Future<void> updateSubtask(Task task, Subtask subtask) async {
    await _dbService.updateSubtask(subtask);
    final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
    if (taskIndex != -1) {
      final subtaskIndex =
          _tasks[taskIndex].subtasks.indexWhere((s) => s.id == subtask.id);
      if (subtaskIndex != -1) {
        _tasks[taskIndex].subtasks[subtaskIndex] = subtask;
        notifyListeners();
      }
    }
  }

  // Delete a subtask from a specific task
  Future<void> deleteSubtask(Task task, int subtaskId) async {
    await _dbService.deleteSubtask(subtaskId);
    final taskIndex = _tasks.indexWhere((t) => t.id == task.id);
    if (taskIndex != -1) {
      _tasks[taskIndex].subtasks.removeWhere((s) => s.id == subtaskId);
      notifyListeners();
    }
  }
}
