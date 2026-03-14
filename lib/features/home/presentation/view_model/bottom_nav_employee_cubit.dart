import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/features/home/presentation/view/home_view.dart';
import 'package:task_manager/features/home/presentation/view_model/bottom_nav_employee_state.dart';
import 'package:task_manager/features/profile/presentation/view/profile_view.dart';
import 'package:task_manager/features/projectTask/presentation/view/project_task_view.dart';



class BottomNavEmployeeCubit extends Cubit<BottomNavEmployeeState> {
  BottomNavEmployeeCubit() : super(BottomNavEmployeeInitialState());


  static BottomNavEmployeeCubit get(context) => BlocProvider.of(context);

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Homeview(),
    const ProjectTaskView(),
    const Profileview()
  ];
  List<BottomNavigationBarItem> bottomItems = const [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
          color: AppColors.grey,
        ),
        label: 'Home'),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.list_alt_sharp,
          color: AppColors.grey,
        ),
        label: 'Project'),
    // BottomNavigationBarItem(
    //     icon: Icon(
    //       Icons.format_list_bulleted_add,
    //       color: AppColors.grey,
    //     ),
    //     label: 'Add Task'),
    BottomNavigationBarItem(
        activeIcon: Icon(
          Icons.person,
          color: AppColors.deepPurple,
        ),
        icon: Icon(
          Icons.person,
          color: AppColors.grey,
        ),
        label: 'Profile')
  ];

  int get selectedIndex => _selectedIndex;
  List<Widget> get screens => _screens;

  void onItemTapped(int index) {
    _selectedIndex = index;
    emit(ChangeBottomNavEmployeeState()); // Emit a state that reflects the updated bottom nav
  }
}
