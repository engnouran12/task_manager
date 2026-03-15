class TicketModel {
  final String id;
  final String patientName;
  final String description;
  final String status;
  final String priority;
  final DateTime dueDate;
  final double slaProgress; // 0.0 to 1.0

  TicketModel({
    required this.id,
    required this.patientName,
    required this.description,
    required this.status,
    required this.priority,
    required this.dueDate,
    required this.slaProgress,
  });
}
