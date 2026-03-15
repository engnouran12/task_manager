import 'package:flutter/material.dart';
import 'package:task_manager/features/ticketing/data/models/ticket_models.dart';

class TicketCard extends StatefulWidget {
  final Ticket ticket;
  final VoidCallback? onTap;

  const TicketCard({super.key, required this.ticket, this.onTap});

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> with SingleTickerProviderStateMixin {
  late AnimationController _blinkingController;

  @override
  void initState() {
    super.initState();
    _blinkingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    
    if (widget.ticket.slaStatus == TicketSLAStatus.blinkingRed) {
      _blinkingController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(TicketCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ticket.slaStatus == TicketSLAStatus.blinkingRed) {
      if (!_blinkingController.isAnimating) {
        _blinkingController.repeat(reverse: true);
      }
    } else {
      _blinkingController.stop();
    }
  }

  @override
  void dispose() {
    _blinkingController.dispose();
    super.dispose();
  }

  Color _getSLAColor(TicketSLAStatus status) {
    switch (status) {
      case TicketSLAStatus.green:
        return Colors.green;
      case TicketSLAStatus.yellow:
        return Colors.orange;
      case TicketSLAStatus.red:
      case TicketSLAStatus.blinkingRed:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.ticket.slaStatus;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.ticket.ticketNumber,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  _buildSLAIndicator(status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.ticket.subject,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    widget.ticket.patient.name,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusChip(widget.ticket.status),
                  _buildPriorityChip(widget.ticket.priority),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSLAIndicator(TicketSLAStatus status) {
    final color = _getSLAColor(status);
    
    if (status == TicketSLAStatus.blinkingRed) {
      return FadeTransition(
        opacity: _blinkingController,
        child: _indicatorContainer(color, 'SLA BREACHED'),
      );
    }

    String label = 'SLA OK';
    if (status == TicketSLAStatus.yellow) label = 'SLA WARNING';
    if (status == TicketSLAStatus.red) label = 'SLA CRITICAL';

    return _indicatorContainer(color, label);
  }

  Widget _indicatorContainer(Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.blue, fontSize: 12),
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color color = Colors.grey;
    if (priority == 'Critical') color = Colors.red;
    if (priority == 'High') color = Colors.deepOrange;
    if (priority == 'Medium') color = Colors.orange;

    return Row(
      children: [
        Icon(Icons.flag, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          priority,
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
