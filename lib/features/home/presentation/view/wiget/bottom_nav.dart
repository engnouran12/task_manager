import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/features/home/presentation/view_model/bottom_nav_employee_cubit.dart';
import 'package:task_manager/features/home/presentation/view_model/bottom_nav_employee_state.dart';

class BottomNavigationBarUser extends StatelessWidget {
  const BottomNavigationBarUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavEmployeeCubit, BottomNavEmployeeState>(
      builder: (context, state) {
        final cubit = BlocProvider.of<BottomNavEmployeeCubit>(context); // Correct way to get the cubit

        return Scaffold(
          body: state is BottomNavEmployeeLoadingState
              ? const Center(child: CircularProgressIndicator())
              : cubit.screens[cubit.selectedIndex],
          bottomNavigationBar: Stack(
            children: [
              BottomNavigationBar(
                items: cubit.bottomItems,
                selectedItemColor: AppColors.deepPurple,
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.selectedIndex,
                onTap: cubit.onItemTapped,
              ),
              Positioned(
                left: cubit.selectedIndex * MediaQuery.of(context).size.width / 3,
                bottom: 0,
                child: Padding(
                  padding:  EdgeInsets.only(
                      left: responsiveComponantSize(context, 2),
                      right: responsiveComponantSize(context, 2)),
                  child: Container(
                    height: responsiveComponantSize(context, 7),
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: const BoxDecoration(
                      color: AppColors.deepPurple,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

