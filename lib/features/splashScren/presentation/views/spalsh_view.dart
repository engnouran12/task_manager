import 'package:flutter/material.dart';
import 'package:task_manager/features/splashScren/presentation/views/widgets/splash_body.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const 
      Scaffold(
        body: SplashBody(),
      
    );
  }
}