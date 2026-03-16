import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/mock/mock_data.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    String displayName = userName ?? 'User';
    String displayRole = role ?? 'Role';
    String initials = displayName.split(' ').length > 1
        ? '${displayName.split(' ')[0][0]}${displayName.split(' ')[1][0]}'
        : displayName[0];

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Avatar from initials (no network image needed)
        CircleAvatar(
          radius: responsiveComponantSize(context, 28),
          backgroundColor: AppColors.deepPurple,
          child: Text(
            initials.toUpperCase(),
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
                    displayName.split(' ')[0],
                    style: AppStyles.styleMedium14(context),
                  ),
                  SizedBox(width: responsiveComponantSize(context, 4)),
                  Text(
                    displayName.split(' ').length > 1 ? displayName.split(' ')[1] : '',
                    style: AppStyles.styleMedium14(context),
                  ),
                ],
              ),
              Text(
                displayRole,
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