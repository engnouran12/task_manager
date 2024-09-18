import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';

Widget customProfilRow({
  required BuildContext context,
  required void Function()? onPressed,
  required   String name ,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        name,
        style: AppStyles.styleSemiBold14(context)
            .copyWith(fontSize: responsiveComponantSize(context, 16), color: AppColors.black),
      ),
      IconButton(
        onPressed:onPressed,
        icon: Icon(
          size: screenWidth(context) / 19,
          Icons.arrow_forward_ios,
          color: AppColors.black,
        ),
      )
    ],
  );
}
