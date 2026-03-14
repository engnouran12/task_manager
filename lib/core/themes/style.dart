import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/themes/colors.dart';

abstract class AppStyles {
  static TextStyle stylebold24(BuildContext context) {
    return  TextStyle(
      color: AppColors.deepPurple,
      fontSize: responsiveComponantSize(context, 24),
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle styleRegular12(BuildContext context) {
    return  TextStyle(
      fontSize:responsiveComponantSize(context, 12),
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle styleSemiBold20(BuildContext context) {
    return  TextStyle(
      color: AppColors.white,
      fontSize: responsiveComponantSize(context, 20),
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle styleSemiBold14(BuildContext context) {
    return  TextStyle(
      color: AppColors.deepPurple,
      fontSize: responsiveComponantSize(context, 14),
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle styleSemiBold12(BuildContext context) {
    return  TextStyle(
      color: AppColors.deepPurple,
      fontSize: responsiveComponantSize(context, 12),
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle styleMedium14(BuildContext context) {
    return  TextStyle(
      color: AppColors.moreLightPurple,
      fontSize: responsiveComponantSize(context, 14),
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    );
  }
}
