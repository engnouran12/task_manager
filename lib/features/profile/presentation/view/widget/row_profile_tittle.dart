import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/shared%20widget/custom_profile_row.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/profileInfo/presentation/views/profile_info_view.dart';

/// Fully static — no Bloc / API / logout logic needed.
class ProfileRowsTittle extends StatelessWidget {
  const ProfileRowsTittle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customProfilRow(
          context: context,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const ProfileInfoView()),
            );
          },
          name: 'Personal Info',
        ),
        const Divider(thickness: 0.9),
        customProfilRow(
          context: context,
          onPressed: () {},
          name: 'Language',
        ),
        const Divider(thickness: 0.9),
        customProfilRow(
          context: context,
          onPressed: () {},
          name: 'Privacy & Security',
        ),
        const Divider(thickness: 0.5),
        customProfilRow(
          context: context,
          onPressed: () {},
          name: 'Help Center',
        ),
        const Divider(thickness: 0.4),
        SizedBox(height: responsiveComponantSize(context, 10)),
        // Log Out button — no actual logout since we bypass login
        InkWell(
          onTap: () {},
          child: Text(
            'Log Out',
            style: AppStyles.styleSemiBold14(context).copyWith(
              fontSize: responsiveComponantSize(context, 16),
              color: AppColors.red,
            ),
          ),
        ),
      ],
    );
  }
}
