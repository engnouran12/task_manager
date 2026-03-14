class TaskModel {
  final String projectId;
  final String? id;
  final String name;
  final String description;
  final DateTime date;
  final DateTime createdat;
  final DateTime updatedat;
  final String employeeId;
  final String priority;
  bool? done;
  bool? hidden;

  TaskModel({
    required this.projectId,
    required this.updatedat,
    required this.createdat,
    required this.date,
    this.id,
    this.done,
    this.hidden,
    required this.name,
    required this.description,
    required this.employeeId,
    required this.priority,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
        projectId: json['projectId'],
        createdat: DateTime.parse(json['createdAt'] as String),
        updatedat: DateTime.parse(json['updatedAt'] as String),
        date: DateTime.parse(json['DueDate'] as String),
        description: json['description'],
        name: json['name'],
        employeeId: json['employeeId'],
        priority: json['priority'],
        done: json['done'] ?? false,
        hidden: json['hidden'] ?? false,
        id: json['_id'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date.toIso8601String(),
      'createdAt': createdat.toIso8601String(),
      'updatedAt': updatedat.toIso8601String(),
      'employeeId': employeeId,
      'projectId': projectId,
      'description': description
    };
  }
}
