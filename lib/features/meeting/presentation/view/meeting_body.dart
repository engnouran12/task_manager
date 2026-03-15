import 'package:flutter/material.dart';
import '../../data/mock_meeting_data.dart';
import 'widget/meeting_card.dart';

class MeetingBody extends StatelessWidget {
  const MeetingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            itemCount: MockMeetingData.meetings.length,
            itemBuilder: (context, index) {
              return MeetingCard(meeting: MockMeetingData.meetings[index]);
            },
          ),
        ),
      ],
    );
  }
}
