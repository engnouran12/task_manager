

import 'package:flutter/cupertino.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';

Widget customTaps({
  required BuildContext context,
required void Function()? ontap,
  required   String name ,
 required bool isAddProject
}) {
 return Flexible(
  child: GestureDetector(
    onTap: ontap,
    child: Container(
      height: screenHeight(context) / 18,
      width: screenWidth(context) / 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:
        isAddProject==true? selectedProjectPriority == name
            ? AppColors.deepPurple.withOpacity(0.3)
            : AppColors.deepPurple.withOpacity(0.1)
        : selectedTaskPriority == name
      ? AppColors.deepPurple.withOpacity(0.3)
            : AppColors.deepPurple.withOpacity(0.1)
      ),
      child: Center(
        child: FittedBox(
          child: Text(
            name,
            style: AppStyles.styleMedium14(context),
          ),
        ),
      ),
    ),
  ),
);
}