// lib/models/task_model.dart
class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final bool isRepeated;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.isRepeated = false,
  });

  // Convert Task object to Map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'isRepeated': isRepeated ? 1 : 0,
    };
  }

  // Factory method to create a Task from a Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'] == 1,
      isRepeated: map['isRepeated'] == 1,
    );
  }
}
