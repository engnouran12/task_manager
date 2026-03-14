class ProjectModel {
  final String? id;
  final String name;
  final DateTime dueDate;
  final String priority;
  final String description;
  final List<String> employees;
  final bool hidden;
  final String managerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  String? status;

  ProjectModel({
    this.status,
    this.id,
    required this.name,
    required this.dueDate,
    required this.priority,
    required this.description,
    required this.employees,
    required this.hidden,
    required this.managerId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a ProjectModel instance from a JSON map
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      status: json['status'] as String? ?? 'todo',
      id: json['_id'] as String?,
      name: json['name'] as String,
      dueDate: DateTime.parse(json['DueDate'] as String),
      priority: json['priority'] as String,
      description: json['description'] as String,
      employees: List<String>.from(json['employees']),
      hidden: json['hidden'] as bool,
      managerId: json['managerId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Method to convert a ProjectModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'DueDate': dueDate.toIso8601String(),
      'priority': priority,
      'description': description,
      'employees': employees,
      'hidden': hidden,
      'managerId': managerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'status': status,
    };
  }

  // CopyWith method to create a copy of the ProjectModel with some updated fields
  ProjectModel copyWith({
    String? id,
    String? name,
    DateTime? dueDate,
    String? priority,
    String? description,
    List<String>? employees,
    bool? hidden,
    String? managerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      description: description ?? this.description,
      employees: employees ?? this.employees,
      hidden: hidden ?? this.hidden,
      managerId: managerId ?? this.managerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }

  // Overriding toString() method to print the ProjectModel in a readable format
  @override
  String toString() {
    return 'ProjectModel{id: $id, name: $name, dueDate: $dueDate, priority: $priority, '
        'description: $description, employees: $employees, hidden: $hidden, '
        'managerId: $managerId, createdAt: $createdAt, updatedAt: $updatedAt, status: $status}';
  }
}
