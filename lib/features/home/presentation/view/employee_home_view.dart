import 'package:flutter/material.dart';
import 'package:task_manager/features/home/presentation/view/wiget/employee_home_body.dart';

class EmployeeHomeView extends StatelessWidget {
  const EmployeeHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: EmployeeHomeBody(),
      ),
    );
  }
}
