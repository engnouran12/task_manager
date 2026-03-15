import 'package:flutter/material.dart';
import 'package:task_manager/core/mock/mock_data.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/shared%20widget/employee_card.dart';

/// Fully static — shows mock employees from MockData, no API / Bloc needed.
class EmployeeList extends StatelessWidget {
  /// When non-null, displays this subset instead of the full mock list
  /// (used by project-detail screens that pass their own employee list).
  final List<EmployeeData>? projectEmployees;

  const EmployeeList({super.key, this.projectEmployees});

  @override
  Widget build(BuildContext context) {
    final employees =
        projectEmployees ?? MockData.employeeDataList.where((e) => e.hidden == false).toList();

    if (employees.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No employees found', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: EmployeeCard(employee: employee),
        );
      },
    );
  }
}