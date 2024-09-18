import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/auth/presentation/view/widget/form_login.dart';

class SignUpBody extends StatelessWidget {
  const SignUpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 SizedBox(
                  height: responsiveComponantSize(context, 67),
                ),
                Text(
                  'Get Started!',
                  style: AppStyles.stylebold24(context),
                ),
                Text(
                  'Sign in to continue',
                  style: AppStyles.styleRegular12(context),
                ),
                 SizedBox(
                  height: responsiveComponantSize(context, 32),
                ),
                 FormLogin()
              ]),
        ),
      )),
    );
  }
}
