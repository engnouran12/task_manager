import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/mock/mock_data.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Avatar from initials (no network image needed)
        CircleAvatar(
          radius: responsiveComponantSize(context, 28),
          backgroundColor: AppColors.deepPurple,
          child: Text(
            '${MockData.adminFirstName[0]}${MockData.adminLastName[0]}',
            style: AppStyles.styleSemiBold14(context)
                .copyWith(color: AppColors.white, fontSize: responsiveComponantSize(context, 16)),
          ),
        ),
        SizedBox(width: responsiveComponantSize(context, 12)),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello 👋', style: AppStyles.styleRegular12(context)),
              Row(
                children: [
                  Text(
                    MockData.adminFirstName,
                    style: AppStyles.styleMedium14(context),
                  ),
                  SizedBox(width: responsiveComponantSize(context, 4)),
                  Text(
                    MockData.adminLastName,
                    style: AppStyles.styleMedium14(context),
                  ),
                ],
              ),
              Text(
                MockData.adminRole,
                style: AppStyles.styleRegular12(context)
                    .copyWith(color: AppColors.grey),
              ),
            ],
          ),
        ),
        Icon(
          Icons.notifications_outlined,
          size: responsiveComponantSize(context, 28),
          color: AppColors.deepPurple,
        ),
      ],
    );
  }
}