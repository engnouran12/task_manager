import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/themes/colors.dart';


Widget customButton({
  required String buttontext,
  required void Function()? onpressed,
  final Color color=AppColors.deepPurple,
  required BuildContext context,
})=> ElevatedButton(
  onPressed: onpressed,
  style: ButtonStyle(
      fixedSize: MaterialStateProperty.all( Size(
          responsiveComponantSize(context, 380),
         responsiveComponantSize(context, 56))),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      backgroundColor: MaterialStateProperty.all(
          color
          ),
          ), // Change to your desired color

  child: Text(
    buttontext,
    style: const TextStyle(color: AppColors.white),
  ),
);

