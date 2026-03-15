class MeetingModel {
  final String id;
  final String title;
  final String organizer;
  final DateTime startTime;
  final int durationMinutes;
  final String meetingLink;
  final String status; // Scheduled, In Progress, Completed

  MeetingModel({
    required this.id,
    required this.title,
    required this.organizer,
    required this.startTime,
    required this.durationMinutes,
    required this.meetingLink,
    required this.status,
  });
}
