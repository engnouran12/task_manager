import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/meeting/data/models/meeting_model.dart';

class MeetingCard extends StatelessWidget {
  final MeetingModel meeting;
  const MeetingCard({super.key, required this.meeting});

  @override
  Widget build(BuildContext context) {
    bool isStartingSoon = meeting.startTime.difference(DateTime.now()).inMinutes <= 15 && meeting.startTime.isAfter(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
        border: isStartingSoon ? Border.all(color: AppColors.darkPurple, width: 2) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                meeting.title,
                style: AppStyles.styleSemiBold14(context).copyWith(color: AppColors.darkPurple),
              ),
              if (isStartingSoon)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Starts Soon',
                    style: AppStyles.styleSemiBold12(context).copyWith(color: Colors.red),
                  ),
                ),
            ],
          ),
          SizedBox(height: responsiveComponantSize(context, 12)),
          Row(
            children: [
              Icon(Icons.person_outline, size: 16, color: AppColors.grey),
              const SizedBox(width: 4),
              Text(
                'Organizer: ${meeting.organizer}',
                style: AppStyles.styleRegular12(context).copyWith(color: AppColors.grey),
              ),
            ],
          ),
          SizedBox(height: responsiveComponantSize(context, 8)),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: AppColors.grey),
              const SizedBox(width: 4),
              Text(
                '${meeting.startTime.hour.toString().padLeft(2, '0')}:${meeting.startTime.minute.toString().padLeft(2, '0')} - ${meeting.durationMinutes} min',
                style: AppStyles.styleRegular12(context).copyWith(color: AppColors.grey),
              ),
            ],
          ),
          SizedBox(height: responsiveComponantSize(context, 16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                meeting.status,
                style: AppStyles.styleMedium14(context).copyWith(color: AppColors.deepPurple),
              ),
              if (meeting.status == 'Scheduled')
                ElevatedButton(
                  onPressed: () {
                    // Logic to Join Zoom Mobile
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    'Join Zoom',
                    style: AppStyles.styleMedium14(context).copyWith(color: AppColors.white),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
