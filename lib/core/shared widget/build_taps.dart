import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';

class TabWidget extends StatelessWidget {
  final String label;

  const TabWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: responsiveComponantSize(context, 16)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.deepPurple.withOpacity(
              0.1), // Replace with AppColors.deepPurple if using a custom color
        ),
        child: Center(
          child: Text(
            label,
            style:  TextStyle(
              fontSize: responsiveComponantSize(context, 8),
              fontWeight: FontWeight.bold,
            ), // Replace with AppStyles.styleMedium14().copyWith(...) if using custom styles
          ),
        ),
      ),
    );
  }
}
