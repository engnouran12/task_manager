import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/mock/mock_data.dart';
import 'package:task_manager/core/shared%20widget/employee_selection_card.dart';
import 'package:task_manager/features/modyify%20employee/view/widget/employee_details_body.dart';

class EmployeeSelectionList extends StatefulWidget {
  const EmployeeSelectionList({super.key});

  @override
  _EmployeeSelectionListState createState() => _EmployeeSelectionListState();
}

class _EmployeeSelectionListState extends State<EmployeeSelectionList> {
  @override
  Widget build(BuildContext context) {
    final employees = MockData.employeeDataList.where((employee) => employee.hidden == false).toList();

    if (employees.isEmpty) {
      return const Center(child: Text('No Employees Found'));
    }

    return SizedBox(
      height: (employees.length) * responsiveComponantSize(context, 100) + 40,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          var isSelected = selectedEmployees.contains(employee.id);
          return Padding(
            padding: EdgeInsets.only(top: responsiveComponantSize(context, 12)),
            child: InkWell(
              onTap: () async {
                if (employee.id!.isNotEmpty) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => EmployeeDetailsBody(employeeId: employee.id!),
                    ),
                  );
                  if (result == true) {
                     setState((){});
                  }
                }
              },
              child: EmployeeSelectionCard(
                employee: employee,
                isSelected: isSelected,
                onChanged: (isChecked) {
                  setState(() {
                    if (isChecked == true) {
                      selectedEmployees.add(employee.id!);
                    } else {
                      selectedEmployees.remove(employee.id!);
                    }
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
