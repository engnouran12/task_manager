import 'dart:async';
import 'package:task_manager/core/models/api_response.dart';
import 'package:task_manager/features/ticketing/data/models/ticket_models.dart';

class MockTicketService {
  final List<Ticket> _mockTickets = [
    Ticket(
      id: '1',
      ticketNumber: 'TKT-2026-001',
      subject: 'System Login Issue',
      description:
          'User cannot login to the portal despite correct credentials.',
      status: 'Open',
      priority: 'High',
      source: 'Mobile App',
      type: 'Technical Support',
      classification: 'Software',
      patient: Patient(id: 'p1', fileNumber: 'F12345', name: 'Ahmed Ali'),
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      slaDueDate: DateTime.now().add(const Duration(hours: 2)),
      isEscalated: false,
    ),
    Ticket(
      id: '2',
      ticketNumber: 'TKT-2026-002',
      subject: 'Patient Record Update',
      description: 'Request to update patient address and phone number.',
      status: 'In Progress',
      priority: 'Medium',
      source: 'Internal Web',
      type: 'Administrative',
      classification: 'Data Management',
      patient: Patient(id: 'p2', fileNumber: 'F67890', name: 'Sara Mohamed'),
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      slaDueDate: DateTime.now().add(const Duration(hours: 1)),
      isEscalated: false,
    ),
    Ticket(
      id: '3',
      ticketNumber: 'TKT-2026-003',
      subject: 'Critical SLA Breach',
      description: 'Emergency ticket that has breached its SLA time.',
      status: 'Open',
      priority: 'Critical',
      source: 'Email',
      type: 'Emergency',
      classification: 'Incident',
      patient: Patient(id: 'p3', fileNumber: 'F11223', name: 'John Doe'),
      createdAt: DateTime.now().subtract(const Duration(hours: 24)),
      slaDueDate: DateTime.now().subtract(const Duration(hours: 2)),
      isEscalated: true,
    ),
    Ticket(
      id: '4',
      ticketNumber: 'TKT-2026-004',
      subject: 'Routine Maintenance',
      description: 'Scheduled maintenance check for equipment.',
      status: 'Pending',
      priority: 'Low',
      source: 'Portal',
      type: 'Maintenance',
      classification: 'Hardware',
      patient: Patient(id: 'p4', fileNumber: 'F44556', name: 'Fatima Hassan'),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      slaDueDate: DateTime.now().add(const Duration(days: 2)),
      isEscalated: false,
    ),
  ];

  Future<ApiResponse<List<Ticket>>> getTickets() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network
    return ApiResponse.success(_mockTickets);
  }

  Future<ApiResponse<Patient>> lookupPatient(String fileNumber) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (fileNumber == 'F12345') {
      return ApiResponse.success(
          Patient(id: 'p1', fileNumber: 'F12345', name: 'Ahmed Ali'));
    }
    return ApiResponse.error('Patient not found');
  }

  Future<ApiResponse<TicketConfig>> getConfig() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ApiResponse.success(TicketConfig(
      sources: ['Mobile App', 'Internal Web', 'Email', 'Portal', 'Call Center'],
      types: [
        'Technical Support',
        'Administrative',
        'Emergency',
        'Maintenance',
        'Billing'
      ],
      classifications: [
        'Software',
        'Hardware',
        'Data Management',
        'Incident',
        'Enquiry'
      ],
      priorities: ['Low', 'Medium', 'High', 'Critical'],
      templates: [
        TicketTemplate(
          name: 'Portal Login Failure',
          subject: 'Issue accessing patient portal',
          description: 'User reports unable to login to the portal.',
          type: 'Technical Support',
          classification: 'Software',
          priority: 'Medium',
        ),
        TicketTemplate(
          name: 'Urgent Data Entry',
          subject: 'Emergency patient record update',
          description: 'Immediate update required for patient biometric data.',
          type: 'Administrative',
          classification: 'Data Management',
          priority: 'High',
        ),
      ],
    ));
  }

  Future<ApiResponse<Ticket>> createTicket(Ticket ticket) async {
    await Future.delayed(const Duration(seconds: 1));
    return ApiResponse.success(ticket, message: 'Ticket created successfully');
  }
}
