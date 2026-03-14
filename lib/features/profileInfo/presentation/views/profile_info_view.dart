
import 'package:flutter/material.dart';
import 'package:task_manager/features/profileInfo/presentation/views/widgets/profile_details_info_body.dart';

class ProfileInfoView extends StatelessWidget {
  const ProfileInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: ProfileDetailsInfoBody(),
      ),
    );
  }
}
