import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';

Widget customProfileInfoRow({
  required BuildContext context,
  required   String title ,
  required   String text ,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(title,
          style: AppStyles.styleRegular12(context).copyWith(
            fontSize: responsiveComponantSize(context, 16),
            color: AppColors.grey,
          )),
      SizedBox(
        height: screenHeight(context) / 180,
      ),
      Text(text,
          style: AppStyles.styleMedium14(context).copyWith(
            fontSize: responsiveComponantSize(context, 16),
            color: AppColors.black,
          )),
    ],
  );
}
