import 'package:flutter/material.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';

class UrgentRow extends StatelessWidget {
  const UrgentRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        'Urgent Project',
        style: AppStyles.styleSemiBold20(context)
            .copyWith(color: AppColors.darkPurple),
      ),
      //const Spacer(),
      Text(
        'Urgent Project',
        style:
            AppStyles.styleMedium14(context).copyWith(color: AppColors.moreLightPurple),
      ),
    ]);
  }
}
