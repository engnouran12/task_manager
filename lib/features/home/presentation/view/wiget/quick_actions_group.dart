import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/ticketing/presentation/view/ticketing_view.dart';
import 'package:task_manager/features/meeting/presentation/view/meeting_view.dart';

class QuickActionsGroup extends StatelessWidget {
  const QuickActionsGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Modules',
          style: AppStyles.styleSemiBold20(context).copyWith(color: AppColors.darkPurple),
        ),
        SizedBox(height: responsiveComponantSize(context, 16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildActionCard(
              context,
              title: 'Ticketing',
              icon: Icons.confirmation_number_outlined,
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TicketingView()),
                );
              },
            ),
            SizedBox(width: responsiveComponantSize(context, 16)),
            _buildActionCard(
              context,
              title: 'Meetings',
              icon: Icons.video_call_outlined,
              color: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MeetingView()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: responsiveComponantSize(context, 16),
            horizontal: responsiveComponantSize(context, 12),
          ),
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
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: responsiveComponantSize(context, 28)),
              ),
              SizedBox(height: responsiveComponantSize(context, 12)),
              Text(
                title,
                style: AppStyles.styleSemiBold14(context).copyWith(color: AppColors.darkPurple),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
