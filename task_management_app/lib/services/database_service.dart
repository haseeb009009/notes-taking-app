// lib/services/database_service.dart

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'task_management.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            dueDate TEXT,
            isCompleted INTEGER,
            isRepeated INTEGER
          )
          ''');
        await db.execute('''
          CREATE TABLE subtasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            taskId INTEGER,
            title TEXT,
            isCompleted INTEGER,
            FOREIGN KEY (taskId) REFERENCES tasks (id) ON DELETE CASCADE
          )
          ''');
      },
    );
  }

  // Insert a new task
  Future<int> insertTask(Task task) async {
    final db = await database;
    final taskId = await db.insert('tasks', task.toMap());

    for (var subtask in task.subtasks) {
      await insertSubtask(taskId, subtask);
    }

    return taskId;
  }

  // Insert a new subtask linked to a task
  Future<int> insertSubtask(int taskId, Subtask subtask) async {
    final db = await database;
    return await db.insert('subtasks', {
      'taskId': taskId,
      'title': subtask.title,
      'isCompleted': subtask.isCompleted ? 1 : 0,
    });
  }

  // Fetch all tasks with their subtasks
  Future<List<Task>> fetchTasks() async {
    final db = await database;
    final taskMaps = await db.query('tasks');

    List<Task> tasks = [];
    for (var taskMap in taskMaps) {
      final taskId = taskMap['id'] as int;
      final subtasks = await fetchSubtasks(taskId);

      tasks.add(Task.fromMap({
        ...taskMap,
        'subtasks': subtasks.map((subtask) => subtask.toMap()).toList(),
      }));
    }
    return tasks;
  }

  // Fetch all subtasks for a specific task
  Future<List<Subtask>> fetchSubtasks(int taskId) async {
    final db = await database;
    final subtaskMaps =
        await db.query('subtasks', where: 'taskId = ?', whereArgs: [taskId]);

    return List.generate(subtaskMaps.length, (i) {
      return Subtask.fromMap(subtaskMaps[i]);
    });
  }

  // Update an existing task in the database
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Update an existing subtask
  Future<int> updateSubtask(Subtask subtask) async {
    final db = await database;
    return await db.update(
      'subtasks',
      subtask.toMap(),
      where: 'id = ?',
      whereArgs: [subtask.id],
    );
  }

  // Delete a subtask by ID
  Future<int> deleteSubtask(int id) async {
    final db = await database;
    return await db.delete(
      'subtasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
