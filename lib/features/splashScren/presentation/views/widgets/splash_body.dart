import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/services/local/shared_data.dart';
import 'package:task_manager/core/services/remote_repo/admin/admin_services.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/auth/presentation/view/sign_up_view.dart';
import 'package:task_manager/features/home/presentation/view/wiget/bottom_bar_admin.dart';
import 'package:task_manager/features/home/presentation/view/wiget/bottom_nav.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody>
    with SingleTickerProviderStateMixin {
  // Animation related variables
  late AnimationController _animationController;
  late Animation<double> _circleScaleAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  bool isAnimationFinished = false;
  var animationDuration = 3000;
  final AdminService _adminService = AdminService();

  @override
  void initState() {
    super.initState();

    animationsImplementation();
    _checkAndCreateAdmin();
    // Navigate to the next screen after a delay
    Future.delayed(Duration(milliseconds: animationDuration), () {
      if (isAnimationFinished) {
        navigateToNextScreen();
      }
    });

  }

  Future<void> _checkAndCreateAdmin() async {
    bool isAdminCreated = await _adminService.checkAdminCreated();
    if (!isAdminCreated) {
      await _adminService.createAdmin('admin@admin.com', 'admin2000');
    }
  }

  void animationsImplementation() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: animationDuration),
      vsync: this,
    );

    _circleScaleAnimation = Tween<double>(begin: 0.0, end: 3.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceIn,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 0.7).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInExpo,
      ),
    );
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInExpo,
      ),
    );

    // Start the animation instantly
    _animationController.forward();

    // Check animation status
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isAnimationFinished = true;
        navigateToNextScreen();
      }
    });
  }

  void navigateToNextScreen() async {
    final LocalRepo localRepo = GetIt.instance<LocalRepo>();
    token = await localRepo.getToken();
    id = await localRepo.getString('id');
    role = await localRepo.getString('role');

    bool? isLogeIn = await localRepo.getBool('isLogIn');
    // Make sure to navigate only if the animation and delay both are finished
    if (isAnimationFinished) {
      // Replace with your navigation logic
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => isLogeIn == true
                ? role != 'employee'
                    ? const BottomNavigationBarAdmin()
                    : const BottomNavigationBarUser()
                : const SignUpView()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => _buildSplashScreen(),
    );
  }

  Widget _buildSplashScreen() =>
      // backgroundColor: AppColors.white,
      Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ScaleTransition(
              scale: _circleScaleAnimation,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary,
                ),
              ),
            ),
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                  opacity: _logoOpacityAnimation,
                  child: Text(
                    'Task Manager',
                    style: AppStyles.stylebold24(context).copyWith(
                        fontSize: responsiveComponantSize(context, 32),
                        color: AppColors.white),
                  )),
            ),
          ],
        ),
      );
}
