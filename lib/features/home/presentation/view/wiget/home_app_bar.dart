import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_cubit.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_state.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  // TODO  instead of calling getEmployeeById in initState you can use BlocListener to trigger a refresher to prevent loading when navigate to this page
  @override
  void initState() {
    super.initState();
    context.read<EmployeesCubit>().getEmployeeById(id!);
  }
  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<EmployeesCubit, EmployeesState>(
      builder: (context, state) {
        if (state is EmployeesLoadingState) {
          return const Center(child: Text('Loading...'));
        } else if (state is EmployeesLoadedState) {
          final employee = state.employee;

          if (employee == null) {
            return const Center(child: Text('Employee data is null.'));
          }

          const String baseUrl = 'http://66.29.130.92:5070/';
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (employee.img != null)
                Container(
                  width: responsiveComponantSize(context, 60), // Set width of the container
                  height: responsiveComponantSize(context, 60), // Set height of the container
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Makes the container circular
                    image: DecorationImage(
                      image: NetworkImage('$baseUrl${employee.img}'),
                      fit: BoxFit.cover, // Fit the image within the circular container
                    ),
                  ),
                ),

              SizedBox(width: responsiveComponantSize(context, 8)),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello', style: AppStyles.styleRegular12(context)),
                    Row(
                      children: [
                        Text(
                          employee.firstName,
                          style: AppStyles.styleMedium14(context),
                        ),
                        SizedBox(width: responsiveComponantSize(context, 4)),
                        Text(
                          employee.secondName,
                          style: AppStyles.styleMedium14(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.notifications,
                size: responsiveComponantSize(context, 30),
                color: AppColors.deepPurple,
              )
            ],
          );
        }  else if (state is EmployeesErrorState) {
          return Center(
              child: Text(ErrorHandling.handleError(state.error)));
        }else{
          return const Center(child: Text('logIn failed'));
        }
      },

    );
  }
}