
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/services/remote_repo/admin/employees/employee.dart';
import 'package:task_manager/core/shared%20widget/custom_button.dart';
import 'package:task_manager/core/shared%20widget/custom_profile_info_row.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_cubit.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_state.dart';
import 'package:task_manager/features/modyify%20employee/view/widget/edit_employee_body.dart';

class EmployeeDetailsBody extends StatefulWidget {
  final String employeeId;
    const EmployeeDetailsBody({super.key, required this.employeeId});

  @override
  State<EmployeeDetailsBody> createState() => _EmployeeDetailsBodyState();
}

class _EmployeeDetailsBodyState extends State<EmployeeDetailsBody> {
  final EmployeeServices employeeServices = EmployeeServices();
  @override
  void initState() {
    super.initState();
    // Initialize any state here if needed
    context.read<EmployeesCubit>().getEmployeeById(widget.employeeId);  // Initialize the Cubit here
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        // When the mobile back button is pressed, return true.
        Navigator.pop(context, true);
        return false; // Prevent the default pop behavior
      },
      child: SafeArea(
        child: Scaffold(
            body:
            BlocBuilder<EmployeesCubit,EmployeesState>(
              builder: (context,state){
                var cubit=EmployeesCubit.get(context);
                if (state is EmployeesLoadingState) {
                  return const Center(child: Text('Loading...'));
                } else if (state is EmployeesLoadedState) {
                  final employee = state.employee;
                  const String baseUrl = 'http://66.29.130.92:5070/';
                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.greyWhite),
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.darkPurple,
                                ),
                                onPressed: () {
                                  Navigator.pop(context,true);
                                },
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Employees Details',
                                  style: AppStyles.stylebold24(context)
                                      .copyWith(color: AppColors.darkPurple),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                   NetworkImage('$baseUrl${employee!.img!}'),
      
                              radius: screenWidth(context) / 5,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${employee.firstName} ',
                                      style: AppStyles.styleSemiBold20(context).copyWith(color: AppColors.black),
                                    ),
                                    Text(
                                      employee.secondName,
                                      style: AppStyles.styleSemiBold20(context).copyWith(color: AppColors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  employee.specialityId.name,
                                  style: AppStyles.styleMedium14(context).copyWith(color: AppColors.grey),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height:24,
                        ),
                        customProfileInfoRow(
                          context: context,
                          title: 'Phone Number',
                          text: employee.phoneNumber.phoneNumber,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        customProfileInfoRow(
                          context: context,
                          title: 'Address',
                          text: employee.address,
                        ),
                        SizedBox(
                          height: screenHeight(context)/3.8,
                        ),
                        customButton(
                            buttontext: 'Edit Employee',
                          onpressed: () async {
                             await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditEmployeeBody(id: widget.employeeId)),
                            );
                         
                          }, context: context,),
                        const SizedBox(
                          height: 15,
                        ),
                        customButton(
                            buttontext: 'Delete Employee',
                            onpressed: ()  {
                              cubit.deleteEmployee(widget.employeeId,);
                              Navigator.pop(context,true);
                            },
                            color: AppColors.red, context: context
                        )
                      ],
                    ),
                  );
                }else if (state is EmployeesErrorState) {
                  return Center(
                      child: Text(ErrorHandling.handleError(state.error )));
                } else {
                  return const Center(child: Text('No Employees Found'));
                }
              },
      
            )
        ),
      ),
    );
  }
}
