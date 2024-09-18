import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/shared%20widget/employee_card.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_cubit.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_state.dart';
import 'package:task_manager/features/modyify%20employee/view/widget/employee_details_body.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key, this.projectEmployees});
  final List<EmployeeData>?projectEmployees;

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  @override
  void initState() {
    super.initState();
    // Initialize any state here if needed
    context.read<EmployeesCubit>().getAllEmployees();  // Initialize the Cubit here
  }

  void _refreshEmployeeSelection() {
    context.read<EmployeesCubit>().getAllEmployees();   }

  @override
  Widget build(BuildContext context) {
    return widget.projectEmployees!=null
        ? ListView.builder(
            itemCount: widget.projectEmployees!.length,
            itemBuilder: (context, index) {
              final employee = widget.projectEmployees![index];
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: InkWell(
                  onTap: () async {
                    if (employee.id!.isNotEmpty&& role!='employee') {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => EmployeeDetailsBody(employeeId: employee.id!),
                        ),
                      );
                      if (result == true) {
                        await EmployeesCubit.get(context).getAllEmployees(); // Refresh the employee data
                      }
                      _refreshEmployeeSelection();

                    } else {
                      // Handle case when ID is null or empty
                    }
                  },
                  child: EmployeeCard(
                    employee: widget.projectEmployees![index],
                  ),
                ),
              );
            },
          )
        :BlocBuilder<EmployeesCubit, EmployeesState>(
      builder: (context, state) {
        var cubit = EmployeesCubit.get(context);
        if (state is EmployeesLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EmployeesLoadedState) {
          final employees = state.employees?.where((employee) {
            return employee.hidden == false;
          }).toList() ?? [];
          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: InkWell(
                  onTap: () async {
                    if (employee.id!.isNotEmpty&& role!='employee') {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => EmployeeDetailsBody(employeeId: employee.id!),
                        ),
                      );
                      if (result == true) {
                        await cubit.getAllEmployees(); // Refresh the employee data
                      }
                      _refreshEmployeeSelection();

                    } else {
                      // Handle case when ID is null or empty
                    }
                  },
                  child: EmployeeCard(
                    employee: employee,
                  ),
                ),
              );
            },
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