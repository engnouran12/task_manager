import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/services/remote_repo/admin/employees/employee.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_cubit.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_state.dart';
import 'package:task_manager/features/profile/presentation/view/widget/profile_img.dart';
import 'package:task_manager/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:task_manager/features/profile/presentation/view_model/profile_state.dart';

class DataProfile extends StatefulWidget {
  const DataProfile({super.key});

  @override
  _DataProfileState createState() => _DataProfileState();
}

class _DataProfileState extends State<DataProfile> {

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getEmployeeById(id!);
  }

  final EmployeeServices employeeServices = EmployeeServices();

  @override
  Widget build(BuildContext context) {
    if (id == null) {
      return const Center(child: Text('Loading ID...'));
    }

    return BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return BlocBuilder<EmployeesCubit, EmployeesState>(
            builder: (context, state) {
              if (state is EmployeesLoadingState) {
                return const Center(child: Text('Loading...'));
              } else if (state is EmployeesLoadedState) {
                final employee = state.employee;

                if (employee == null) {
                  return const Center(child: Text('Employee data is null.'));
                }

                const String baseUrl = 'http://66.29.130.92:5070/';
                return Column(
                  children: [
                    ProfileImg(
                      img: '$baseUrl${employee.img}',
                    ),
                    SizedBox(
                      height: responsiveComponantSize(context, 16),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          employee.firstName,
                          style: AppStyles.styleSemiBold20(context).copyWith(color: AppColors.black),
                        ),
                        SizedBox(width: responsiveComponantSize(context, 4)),
                        Text(
                          employee.secondName,
                          style: AppStyles.styleSemiBold20(context).copyWith(color: AppColors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: responsiveComponantSize(context, 8),
                    ),
                    Text(
                      employee.specialityId.name,
                      style: AppStyles.styleMedium14(context).copyWith(color: AppColors.grey),
                    ),
                  ],
                );
              } else if (state is EmployeesErrorState) {
                return Center(
                    child: Text(ErrorHandling.handleError(state.error)));
              } else {
                return const Center(child: Text('No Employees Found'));
              }
            },
          );
        }
    );
  }
}
