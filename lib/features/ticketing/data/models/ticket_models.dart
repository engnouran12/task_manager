enum TicketSLAStatus { green, yellow, red, blinkingRed }

class Patient {
  final String id;
  final String fileNumber;
  final String name;
  final String? phone;

  Patient({
    required this.id,
    required this.fileNumber,
    required this.name,
    this.phone,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      fileNumber: json['fileNumber'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}

class Ticket {
  final String id;
  final String ticketNumber;
  final String subject;
  final String description;
  final String status;
  final String priority;
  final String source;
  final String type;
  final String classification;
  final Patient patient;
  final DateTime createdAt;
  final DateTime slaDueDate;
  final bool isEscalated;
  final double? budget;

  Ticket({
    required this.id,
    required this.ticketNumber,
    required this.subject,
    required this.description,
    required this.status,
    required this.priority,
    required this.source,
    required this.type,
    required this.classification,
    required this.patient,
    required this.createdAt,
    required this.slaDueDate,
    this.isEscalated = false,
    this.budget,
  });

  double get slaProgress {
    final now = DateTime.now();
    final totalDuration = slaDueDate.difference(createdAt).inMinutes;
    final remainingDuration = slaDueDate.difference(now).inMinutes;
    
    if (totalDuration <= 0) return 0.0;
    if (remainingDuration <= 0) return 0.0;
    
    return remainingDuration / totalDuration;
  }

  TicketSLAStatus get slaStatus {
    final progress = slaProgress;
    final now = DateTime.now();
    
    if (now.isAfter(slaDueDate) || progress <= 0) {
      return isEscalated ? TicketSLAStatus.blinkingRed : TicketSLAStatus.red;
    }
    
    if (progress < 0.2) return TicketSLAStatus.red;
    if (progress < 0.5) return TicketSLAStatus.yellow;
    return TicketSLAStatus.green;
  }

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      ticketNumber: json['ticketNumber'],
      subject: json['subject'],
      description: json['description'],
      status: json['status'],
      priority: json['priority'],
      source: json['source'],
      type: json['type'],
      classification: json['classification'],
      patient: Patient.fromJson(json['patient']),
      createdAt: DateTime.parse(json['createdAt']),
      slaDueDate: DateTime.parse(json['slaDueDate']),
      isEscalated: json['isEscalated'] ?? false,
      budget: json['budget']?.toDouble(),
    );
  }
}

class TicketConfig {
  final List<String> sources;
  final List<String> types;
  final List<String> classifications;
  final List<String> priorities;
  final List<TicketTemplate> templates;

  TicketConfig({
    required this.sources,
    required this.types,
    required this.classifications,
    required this.priorities,
    required this.templates,
  });
}

class TicketTemplate {
  final String name;
  final String subject;
  final String description;
  final String type;
  final String classification;
  final String priority;

  TicketTemplate({
    required this.name,
    required this.subject,
    required this.description,
    required this.type,
    required this.classification,
    required this.priority,
  });
}
