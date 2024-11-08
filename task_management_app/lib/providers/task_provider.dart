import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];
  DatabaseService _dbService = DatabaseService();

  List<TaskModel> get tasks => _tasks;

  Future<void> addTask(TaskModel task) async {
    task.id = await _dbService.insertTask(task);
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> loadTasks() async {
    _tasks = await _dbService.getTasks();
    notifyListeners();
  }

  Future<void> updateTask(TaskModel task) async {
    await _dbService.updateTask(task);
    int index = _tasks.indexWhere((t) => t.id == task.id);
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
