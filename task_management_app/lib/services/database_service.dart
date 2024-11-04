// lib/services/database_service.dart

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  factory DatabaseService() => _instance;

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
        print('Creating tasks table...');
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            dueDate TEXT NOT NULL,
            isCompleted INTEGER DEFAULT 0,
            isRepeated INTEGER DEFAULT 0
          )
          ''');
      },
    );
  }

  // Insert a new task and print result
  Future<int> insertTask(Task task) async {
    final db = await database;
    int taskId = await db.insert('tasks', task.toMap());
    print('Inserted task with ID: $taskId');
    return taskId;
  }

  // Fetch tasks from the database and print result
  Future<List<Task>> fetchTasks() async {
    final db = await database;
    final taskMaps = await db.query('tasks');
    print('Fetched tasks: $taskMaps'); // Print the tasks fetched
    return taskMaps.map((taskMap) => Task.fromMap(taskMap)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
