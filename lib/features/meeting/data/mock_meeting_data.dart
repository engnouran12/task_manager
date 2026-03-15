import 'models/meeting_model.dart';

class MockMeetingData {
  static List<MeetingModel> meetings = [
    MeetingModel(
      id: "MTG-201",
      title: "Weekly Sync: Mobile Team",
      organizer: "Ali Hassan",
      startTime: DateTime.now().add(const Duration(minutes: 5)),
      durationMinutes: 45,
      meetingLink: "https://zoom.us/j/123456789",
      status: "Scheduled",
    ),
    MeetingModel(
      id: "MTG-202",
      title: "Project Alpha Kickoff",
      organizer: "Mona Zak",
      startTime: DateTime.now().add(const Duration(hours: 3)),
      durationMinutes: 60,
      meetingLink: "https://zoom.us/j/987654321",
      status: "Scheduled",
    ),
    MeetingModel(
      id: "MTG-203",
      title: "Design Review - Tab Bar",
      organizer: "Sarah Lee",
      startTime: DateTime.now().subtract(const Duration(hours: 1)),
      durationMinutes: 30,
      meetingLink: "https://zoom.us/j/111222333",
      status: "Completed",
    ),
  ];
}
