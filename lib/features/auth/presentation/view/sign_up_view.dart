
import 'package:flutter/material.dart';
import 'package:task_manager/features/auth/presentation/view/widget/sign_up_body.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: SignUpBody(),
      ),
    );
  }
}
