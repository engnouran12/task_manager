import 'package:flutter/material.dart';

import '../../data/mock_ticketing_data.dart';
import 'widget/ticket_card.dart';

class TicketingBody extends StatelessWidget {
  const TicketingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            itemCount: MockTicketingData.tickets.length,
            itemBuilder: (context, index) {
              return TicketCard(ticket: MockTicketingData.tickets[index]);
            },
          ),
        ),
      ],
    );
  }
}
