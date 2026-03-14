import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/shared%20widget/employee_selection_card.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_cubit.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_state.dart';
import 'package:task_manager/features/modyify%20employee/view/widget/employee_details_body.dart';

class EmployeeSelectionList extends StatefulWidget {
  const EmployeeSelectionList({super.key});

  @override
  _EmployeeSelectionListState createState() => _EmployeeSelectionListState();
}

class _EmployeeSelectionListState extends State<EmployeeSelectionList> {

  @override
  void initState() {
    super.initState();
    // Initialize the EmployeesCubit and SpecialtyCubit
    context.read<EmployeesCubit>().getAllEmployees();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesCubit, EmployeesState>(
      builder: (context, state) {
        final cubit = EmployeesCubit.get(context);
        if (state is EmployeesLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EmployeesLoadedState) {
          final employees = state.employees?.where((employee) {
            return employee.hidden == false;
          }).toList() ?? [];

          return SizedBox(
            height: (employees.length) * responsiveComponantSize(context, 100)+40,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                var isSelected = selectedEmployees.contains(employee.id);
                return Padding(
                  padding:  EdgeInsets.only(top: responsiveComponantSize(context, 12)),
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
                          cubit.getAllEmployees(); // Refresh the employee data
                        }
                      } else {
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
        } else if (state is EmployeesErrorState) {
          return Center(
              child: Text(ErrorHandling.handleError(state.error )));
        } else {
          return const Center(child: Text('No Employees Found'));
        }
      },
    );
  }
}

