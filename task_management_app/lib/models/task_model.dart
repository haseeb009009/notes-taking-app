//lib/models/task_model.dart
class TaskModel {
  final int? id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isRepeated;
  final bool isCompleted;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isRepeated = false,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isRepeated': isRepeated ? 1 : 0,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isRepeated: map['isRepeated'] == 1,
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
