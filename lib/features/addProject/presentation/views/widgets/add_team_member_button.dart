import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/services/remote_repo/admin/employees/employee.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_cubit.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_state.dart';

import '../../../../../core/constant/constant.dart';

class AddTeamMemberOrProjectManagerButton extends StatefulWidget {
  const AddTeamMemberOrProjectManagerButton(
      {super.key, required this.text, required this.onpressedScreen,});
  final String text;

  final Future<void> Function()? onpressedScreen;

  @override
  State<AddTeamMemberOrProjectManagerButton> createState() => _AddTeamMemberOrProjectManagerButtonState();
}

class _AddTeamMemberOrProjectManagerButtonState extends State<AddTeamMemberOrProjectManagerButton> {
  final EmployeeServices employeeServices = EmployeeServices();
  EmployeeData? selectedEmployee; // Change to EmployeeData
  @override
  void initState() {
    super.initState();
    selectedEmployees;
    context.read<EmployeesCubit>().getAllEmployees();
  }
  @override
  Widget build(BuildContext context) {
    return selectedEmployees.isEmpty
        ? Container(
      height: responsiveComponantSize(context, 56),
      width: screenWidth(context),
      decoration: BoxDecoration(
          color: AppColors.deepPurple.withOpacity(.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.deepPurple.withOpacity(.1))),
      child: Padding(
        padding:  EdgeInsets.only(left:  responsiveComponantSize(context, 20)),
        child: Row(
          children: [
            Text(
              textAlign: TextAlign.center,
              widget.text,
              style: AppStyles.styleMedium14(context).copyWith(fontSize:  responsiveComponantSize(context, 16)),
            ),
            const Spacer(),
            IconButton(
                icon: const Icon(Icons.add_box, color: AppColors.deepPurple),
                onPressed: widget.onpressedScreen
            )
          ],
        ),
      ),
    )
        : BlocBuilder<EmployeesCubit, EmployeesState>(
      builder: (context, state) {
        EmployeesCubit.get(context);
        if (state is EmployeesLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EmployeesLoadedState) {
          final employees = state.employees ?? [];
          final filteredEmployees = employees.where((employee) {
            return selectedEmployees.contains(employee.id);
          }).toList();
          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField2<EmployeeData>(
                  isExpanded: true,
                  value: selectedEmployee,
                  onChanged: (EmployeeData? value) {
                    setState(() {
                      selectedEmployee = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: filteredEmployees.map((employee) {
                    return DropdownMenuItem<EmployeeData>(
                      value: employee,
                      child: Text('${employee.firstName} ${employee.secondName}'),
                    );
                  }).toList(),
                  hint: Text(
                    selectedEmployee != null
                        ? '${selectedEmployee!.firstName} ${selectedEmployee!.secondName}'
                        :'${filteredEmployees.first.firstName} ${filteredEmployees.first.secondName}',
                    style: AppStyles.styleSemiBold14(context)
                        .copyWith(fontSize:  responsiveComponantSize(context, 16),color: Colors.black),
                  ),
                ),
              ),
              IconButton(
                  icon: const Icon(Icons.add_box, color: AppColors.deepPurple),
                  onPressed: widget.onpressedScreen)
            ],
          );
        } else if (state is EmployeesErrorState) {
          return Center(child: Text('Error: ${state.error.toString()}'));
        } else {
          return const Center(child: Text('No Employees Found'));
        }
      },
    );
  }
}