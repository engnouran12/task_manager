import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';


import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/profile/presentation/view/widget/profile_data.dart';
import 'package:task_manager/features/profile/presentation/view/widget/row_profile_tittle.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F4FB),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: responsiveComponantSize(context, 55),
                  bottom: responsiveComponantSize(context, 24),
                ),
                child: Text(
                  'Profile',
                  style: AppStyles.stylebold24(context),
                ),
              ),
            ),
            const Center(child: DataProfile()),
            SizedBox(height: responsiveComponantSize(context, 30)),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: responsiveComponantSize(context, 24)),
              child: const ProfileRowsTittle(),
            ),
          ],
        ),
      ),
    );
  }
}
