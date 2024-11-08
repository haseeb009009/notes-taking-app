class TaskModel {
  int? id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
  bool isRepeated;
  List<String> subtasks;
  List<bool> subtaskCompletion;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.isRepeated = false,
    this.subtasks = const [],
    this.subtaskCompletion = const [],
  });

  double get progress {
    if (subtasks.isEmpty) return isCompleted ? 1.0 : 0.0;
    int completedSubtasks = subtaskCompletion.where((c) => c).length;
    return completedSubtasks / subtasks.length;
  }

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

  static fromMap(Map<String, Object?> task) {}
}
