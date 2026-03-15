import 'package:flutter/material.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/features/employees/presentation/views/widget/add_employee_body.dart';
import 'package:task_manager/features/employees/presentation/views/widget/employees_body.dart';

/// Fully static Employees list view — no API / Bloc needed.
class EmployeesView extends StatelessWidget {
  const EmployeesView({super.key, this.projectEmployees});

  final List<EmployeeData>? projectEmployees;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: projectEmployees == null
            ? FloatingActionButton(
                backgroundColor: AppColors.deepPurple,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddEmployeeBody(),
                    ),
                  );
                },
                child: const Icon(
                  Icons.person_add_alt_1,
                  color: AppColors.white,
                  size: 30,
                ),
              )
            : null,
        body: EmployeesBody(projectEmployees: projectEmployees),
      ),
    );
  }
}
