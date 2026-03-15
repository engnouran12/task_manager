import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/ticketing/data/models/ticket_model.dart';
import 'package:task_manager/features/ticketing/data/mock_ticketing_data.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;
  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ticket.id,
                style: AppStyles.styleSemiBold14(context).copyWith(color: AppColors.darkPurple),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.moreLightPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ticket.status,
                  style: AppStyles.styleSemiBold12(context).copyWith(color: AppColors.deepPurple),
                ),
              ),
            ],
          ),
          SizedBox(height: responsiveComponantSize(context, 12)),
          Text(
            ticket.patientName,
            style: AppStyles.styleSemiBold14(context),
          ),
          SizedBox(height: responsiveComponantSize(context, 4)),
          Text(
            ticket.description,
            style: AppStyles.styleRegular12(context).copyWith(color: AppColors.grey),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: responsiveComponantSize(context, 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.flag_outlined, size: 16, color: ticket.priority == 'High' ? Colors.red : AppColors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${ticket.priority} Priority',
                    style: AppStyles.styleSemiBold12(context).copyWith(color: ticket.priority == 'High' ? Colors.red : AppColors.grey),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.timer_outlined, size: 16, color: MockTicketingData.getSLAColor(ticket.slaProgress)),
                  const SizedBox(width: 4),
                  Text(
                    'SLA',
                    style: AppStyles.styleSemiBold12(context).copyWith(color: MockTicketingData.getSLAColor(ticket.slaProgress)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
