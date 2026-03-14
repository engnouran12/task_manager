import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/features/home/presentation/view_model/bottom_nav_bar_cubit.dart';
import 'package:task_manager/features/home/presentation/view_model/bottom_nav_bar_state.dart';

class BottomNavigationBarAdmin extends StatelessWidget {
  const BottomNavigationBarAdmin({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
    builder: (context, state) {
      var cubit = BottomNavBarCubit.get(context);
      return Scaffold(
        body:State is BottomNavBarLoadingState
            ? const Center(child: CircularProgressIndicator())
            :cubit.screens[cubit.selectedIndex],
        bottomNavigationBar: Stack(children: [
          BottomNavigationBar(
            items:cubit.bottomItems,
            selectedItemColor: AppColors.deepPurple,
            type: BottomNavigationBarType.fixed,
            currentIndex:cubit.selectedIndex,
            onTap:cubit.onItemTapped,
          ),
          Positioned(
            left: cubit.selectedIndex * MediaQuery.of(context).size.width / 4,
            bottom: 0, // Add space between the label and the underline
            child: Padding(
              padding:  EdgeInsets.only(
                  left: responsiveComponantSize(context, 2),
                  right: responsiveComponantSize(context, 2)),
              child: Container(
                height: responsiveComponantSize(context, 7),
                width: MediaQuery.of(context).size.width / 4,
                // Adjust the thickness here

                decoration: const BoxDecoration(
                  color: AppColors.deepPurple, // Set the underline color
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight:
                      Radius.circular(10)), // Adjust the radius as needed
                ),
              ),
            ),
          ),
        ]),
      );
    }

    );
  }
}
