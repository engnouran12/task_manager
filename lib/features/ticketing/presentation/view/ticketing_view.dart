import 'package:flutter/material.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'ticketing_body.dart';

class TicketingView extends StatelessWidget {
  const TicketingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ticketing',
          style: AppStyles.styleSemiBold20(context).copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.darkPurple,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: const TicketingBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.darkPurple,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
