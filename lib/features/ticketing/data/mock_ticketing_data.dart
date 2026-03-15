import 'models/ticket_model.dart';
import 'package:flutter/material.dart';

class MockTicketingData {
  static List<TicketModel> tickets = [
    TicketModel(
      id: "TKT-1045",
      patientName: "Ahmed Ali",
      description: "Patient complained about long wait times in the orthopedics department.",
      status: "Open",
      priority: "High",
      dueDate: DateTime.now().add(const Duration(hours: 1)),
      slaProgress: 0.1, // Near breach
    ),
    TicketModel(
      id: "TKT-1046",
      patientName: "Sarah Connor",
      description: "Billing discrepancy on invoice #4002.",
      status: "In Progress",
      priority: "Medium",
      dueDate: DateTime.now().add(const Duration(hours: 24)),
      slaProgress: 0.6, // Fine
    ),
    TicketModel(
      id: "TKT-1047",
      patientName: "Mohammed Yasin",
      description: "Requesting a change of doctor.",
      status: "Resolved",
      priority: "Low",
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      slaProgress: 1.0, // Completed
    ),
    TicketModel(
      id: "TKT-1048",
      patientName: "Fatima Noor",
      description: "Medication allergy missing from record.",
      status: "Open",
      priority: "High",
      dueDate: DateTime.now().add(const Duration(minutes: 30)),
      slaProgress: 0.05, // Critical SLA
    ),
  ];

  static Color getSLAColor(double progress) {
    if (progress > 0.5) return Colors.green;
    if (progress > 0.2) return Colors.orange;
    return Colors.red;
  }
}
