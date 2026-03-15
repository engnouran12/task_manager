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
  
  // TR-02 Required Fields
  final String? status; 
  final double? completionRate; 
  final DateTime? expectedStartDate;
  final DateTime? expectedEndDate;
  final List<String>? responsibleEmployees;
  final List<String>? attachmentUrls;

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
    this.status,
    this.completionRate,
    this.expectedStartDate,
    this.expectedEndDate,
    this.responsibleEmployees,
    this.attachmentUrls,
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
        id: json['_id'] ?? '',
        status: json['status'],
        completionRate: json['completionRate'] != null ? double.parse(json['completionRate'].toString()) : null,
        expectedStartDate: json['expectedStartDate'] != null ? DateTime.parse(json['expectedStartDate'] as String) : null,
        expectedEndDate: json['expectedEndDate'] != null ? DateTime.parse(json['expectedEndDate'] as String) : null,
        responsibleEmployees: json['responsibleEmployees'] != null ? List<String>.from(json['responsibleEmployees']) : null,
        attachmentUrls: json['attachmentUrls'] != null ? List<String>.from(json['attachmentUrls']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date.toIso8601String(),
      'createdAt': createdat.toIso8601String(),
      'updatedAt': updatedat.toIso8601String(),
      'employeeId': employeeId,
      'projectId': projectId,
      'description': description,
      'status': status,
      'completionRate': completionRate,
      'expectedStartDate': expectedStartDate?.toIso8601String(),
      'expectedEndDate': expectedEndDate?.toIso8601String(),
      'responsibleEmployees': responsibleEmployees,
      'attachmentUrls': attachmentUrls,
    };
  }
}
