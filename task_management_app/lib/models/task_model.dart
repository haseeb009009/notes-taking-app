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

  // Convert to map for storing in the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'isRepeated': isRepeated ? 1 : 0,
      'subtasks': subtasks.join(','), // Serialize list to string
      'subtaskCompletion': subtaskCompletion.map((e) => e ? '1' : '0').join(','), // Serialize list of bools
    };
  }

  // Create a TaskModel from a map
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'] == 1,
      isRepeated: map['isRepeated'] == 1,
      subtasks: map['subtasks'] != null ? map['subtasks'].split(',') : [],
      subtaskCompletion: map['subtaskCompletion'] != null
          ? map['subtaskCompletion'].split(',').map((e) => e == '1').toList()
          : [],
    );
  }
}
