import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/Speciality/speciality_model.dart';
import 'package:task_manager/core/services/remote_repo/admin/employees/employee.dart';
import 'package:task_manager/core/shared%20widget/employee_card.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_cubit.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_state.dart';
import 'package:task_manager/features/modyify%20employee/view/widget/employee_details_body.dart';

class EmployeesSpecialityList extends StatefulWidget {
  final Speciality specialty;
   const EmployeesSpecialityList({super.key, required this.specialty});

  @override
  State<EmployeesSpecialityList> createState() => _EmployeesSpecialityListState();
}

class _EmployeesSpecialityListState extends State<EmployeesSpecialityList> {
  final EmployeeServices employeeServices = EmployeeServices();
  @override
  void initState() {
    super.initState();
    // Initialize any state here if needed
    context.read<EmployeesCubit>().getAllEmployees();
  }
  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<EmployeesCubit, EmployeesState>(
        builder: (context, state) {
          var cubit = EmployeesCubit.get(context);
          if (state is EmployeesLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeesLoadedState) {
            final employees = state.employees?.where((employee) {
                  return employee.specialityId.name == widget.specialty.name;
                }).toList() ?? [];
            if (employees.isEmpty) {
              return const Center(child: Text('No Employees Found'));
            } else  {
              return ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  return Padding(
                    padding:  EdgeInsets.only(top: responsiveComponantSize(context, 8)),
                    child: InkWell(
                      onTap: () async {
                        if (employee.id!.isNotEmpty&&role!='employee') {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) =>
                                  EmployeeDetailsBody(employeeId: employee.id!),
                            ),
                          );
                          if (result == true) {
                            cubit.getAllEmployees();
                            // Refresh the employee data
                          }
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
            }
          } else if (state is EmployeesErrorState) {
            return Center(
                child: Text(ErrorHandling.handleError(state.error)));
        }else{
            return const Center(child: Text('logIn failed'));
          }
        }

    );
  }
}
