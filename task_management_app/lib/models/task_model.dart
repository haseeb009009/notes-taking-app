// lib/models/task_model.dart

class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final bool isRepeated;
  final List<Subtask> subtasks; // Add a list for subtasks

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.isRepeated = false,
    this.subtasks = const [], // Default to an empty list
  });

  // Add the copyWith method here
  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    bool? isRepeated,
    List<Subtask>? subtasks,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      isRepeated: isRepeated ?? this.isRepeated,
      subtasks: subtasks ?? this.subtasks,
    );
  }

  // Convert Task to Map for database
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

  // Convert Map to Task for database
  static Task fromMap(Map<String, dynamic> map) {
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

// Define a Subtask model as well
class Subtask {
  final String name;
  final bool isCompleted;

  Subtask({required this.name, this.isCompleted = false});
}
