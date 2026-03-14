
import 'package:flutter/material.dart';
import 'package:task_manager/features/employees/presentation/views/widget/employee_select_body.dart';

class EmployeeSelectView extends StatelessWidget {
  const EmployeeSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: AddEmployeeToProject(),
      ),
    );
  }
}
