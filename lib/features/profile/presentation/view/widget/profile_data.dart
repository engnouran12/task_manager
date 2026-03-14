import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/mock/mock_data.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';

/// Fully static — no API / Bloc / id needed.
class DataProfile extends StatelessWidget {
  const DataProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar circle with initials
        CircleAvatar(
          radius: responsiveComponantSize(context, 48),
          backgroundColor: AppColors.deepPurple,
          child: Text(
            '${MockData.adminFirstName[0]}${MockData.adminLastName[0]}',
            style: TextStyle(
              fontSize: responsiveComponantSize(context, 32),
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: responsiveComponantSize(context, 16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              MockData.adminFirstName,
              style: AppStyles.styleSemiBold20(context)
                  .copyWith(color: AppColors.black),
            ),
            SizedBox(width: responsiveComponantSize(context, 4)),
            Text(
              MockData.adminLastName,
              style: AppStyles.styleSemiBold20(context)
                  .copyWith(color: AppColors.black),
            ),
          ],
        ),
        SizedBox(height: responsiveComponantSize(context, 8)),
        Text(
          MockData.adminRole,
          style: AppStyles.styleMedium14(context)
              .copyWith(color: AppColors.grey),
        ),
      ],
    );
  }
}
