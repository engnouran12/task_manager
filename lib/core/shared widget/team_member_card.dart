import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/services/remote_repo/admin/employees/employee.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_cubit.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_state.dart';
import 'package:task_manager/features/employees/presentation/views/employee_view.dart';

class AllemployeesCard extends StatefulWidget {
  AllemployeesCard({super.key, this.projectEmployeeId});
  final List<String>? projectEmployeeId;
  @override
  State<AllemployeesCard> createState() => _AllemployeesCardState();
}

class _AllemployeesCardState extends State<AllemployeesCard> {
  late EmployeesCubit _employeesCubit;

  @override
  void initState() {
    super.initState();
    final employeeServices = EmployeeServices();
    _employeesCubit = EmployeesCubit(employeeServices);
    _employeesCubit.getAllEmployees();
  }

  @override
  void dispose() {
    _employeesCubit.close();
    super.dispose();
  }

  void _refreshEmployeeSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const String baseUrl = 'http://66.29.130.92:5070/';

    return widget.projectEmployeeId != null
        ? BlocBuilder<EmployeesCubit, EmployeesState>(
            bloc: _employeesCubit,
            builder: (context, state) {
              if (state is EmployeesLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is EmployeesLoadedState) {
                final employees = state.employees?.where((employee) {
                      return widget.projectEmployeeId!.contains(employee.id);
                    }).toList() ??
                    [];
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: responsiveComponantSize(context, 24)),
                  child: Container(
                    height: screenHeight(context) / 7.5,
                    width: screenWidth(context),
                    margin: EdgeInsets.only(
                        bottom: responsiveComponantSize(context, 15)),
                    padding:
                        EdgeInsets.all(responsiveComponantSize(context, 16)),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.greyWhite),
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Employees',
                              style: AppStyles.styleSemiBold14(context),
                            ),
                            InkWell(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EmployeesView(
                                            projectEmployees: employees,
                                          )),
                                );
                                context
                                    .read<EmployeesCubit>()
                                    .getEmployeeById(id!);

                                if (result == true) {
                                  _employeesCubit.getAllEmployees();
                                }
                                _refreshEmployeeSelection();
                              },
                              child: Text(
                                'See All',
                                style: AppStyles.styleMedium14(context)
                                    .copyWith(color: AppColors.moreLightPurple),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: responsiveComponantSize(context, 12)),
                        employees.isEmpty
                            ? const Center(child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('No Employees Found'),
                            ))
                            : SizedBox(
                                height: responsiveComponantSize(context, 45),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: employees.length > 6
                                            ? 6
                                            : employees.length,
                                        itemBuilder: (context, index) {
                                          return CircleAvatar(
                                            radius: responsiveComponantSize(
                                                context, 25),
                                            backgroundImage: employees[index]
                                                        .img !=
                                                    null
                                                ? NetworkImage(
                                                    '$baseUrl${employees[index].img!}')
                                                : null,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          responsiveComponantSize(context, 10),
                                    ),
                                    if (employees.length > 6)
                                      CircleAvatar(
                                        child: Text("+${employees.length - 6}"),
                                      ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              } else if (state is EmployeesErrorState) {
                return Center(
                    child: Text(ErrorHandling.handleError(state.error)));
              } else {
                return const Center(child: Text('No Employees Found'));
              }
            },
          )
        : BlocBuilder<EmployeesCubit, EmployeesState>(
            bloc: _employeesCubit,
            builder: (context, state) {
              if (state is EmployeesLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is EmployeesLoadedState) {
                final employees = state.employees?.where((employee) {
                      return employee.hidden == false;
                    }).toList() ??
                    [];

                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: responsiveComponantSize(context, 24)),
                  child: Container(
                    height: screenHeight(context) / 7.5,
                    width: screenWidth(context),
                    margin: EdgeInsets.only(
                        bottom: responsiveComponantSize(context, 15)),
                    padding:
                        EdgeInsets.all(responsiveComponantSize(context, 16)),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.greyWhite),
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Employees',
                              style: AppStyles.styleSemiBold14(context),
                            ),
                            InkWell(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EmployeesView()),
                                );
                                context
                                    .read<EmployeesCubit>()
                                    .getEmployeeById(id!);

                                if (result == true) {
                                  _employeesCubit.getAllEmployees();
                                }
                                _refreshEmployeeSelection();
                              },
                              child: Text(
                                'See All',
                                style: AppStyles.styleMedium14(context)
                                    .copyWith(color: AppColors.moreLightPurple),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: responsiveComponantSize(context, 12)),
                        SizedBox(
                          height: responsiveComponantSize(context, 45),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: employees.length > 6
                                      ? 6
                                      : employees.length,
                                  itemBuilder: (context, index) {
                                    return CircleAvatar(
                                      radius:
                                          responsiveComponantSize(context, 25),
                                      backgroundImage: employees[index].img !=
                                              null
                                          ? NetworkImage(
                                              '$baseUrl${employees[index].img!}')
                                          : null,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: responsiveComponantSize(context, 10),
                              ),
                              if (employees.length > 6)
                                CircleAvatar(
                                  child: Text("+${employees.length - 6}"),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
}
