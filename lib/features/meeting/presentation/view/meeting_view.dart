import 'package:flutter/material.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'meeting_body.dart';

class MeetingView extends StatelessWidget {
  const MeetingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meetings',
          style: AppStyles.styleSemiBold20(context).copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.darkPurple,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: const MeetingBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.darkPurple,
        child: const Icon(Icons.add_link, color: AppColors.white),
      ),
    );
  }
}
