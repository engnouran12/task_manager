
import 'package:flutter/material.dart';
import 'package:task_manager/features/profile/presentation/view/widget/profile_body.dart';

class Profileview extends StatelessWidget {
  const Profileview({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: ProfileBody(),
      ),
    );
  }
}
