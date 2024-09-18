import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/features/addTask/presentation/views/add_task_view.dart';
import 'package:task_manager/features/home/presentation/view/home_view.dart';
import 'package:task_manager/features/home/presentation/view_model/bottom_nav_bar_state.dart';
import 'package:task_manager/features/profile/presentation/view/profile_view.dart';
import 'package:task_manager/features/projectTask/presentation/view/project_task_view.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit() : super(BottomNavBarIntialState());

  static BottomNavBarCubit get(context) => BlocProvider.of(context);

  int selectedIndex = 0;

  List<BottomNavigationBarItem> get bottomItems => [
    const BottomNavigationBarItem(
      activeIcon: Icon(
        Icons.home,
        color: AppColors.deepPurple,
      ),
      icon: Icon(
        Icons.home,
        color: AppColors.grey,
      ),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      activeIcon: Icon(
        Icons.list_alt_sharp,
        color: AppColors.deepPurple,
      ),
      icon: Icon(
        Icons.list_alt_sharp,
        color: AppColors.grey,
      ),
      label: 'Project',
    ),
    const BottomNavigationBarItem(
      activeIcon: Icon(
        Icons.format_list_bulleted_add,
        color: AppColors.deepPurple,
      ),
      icon: Icon(
        Icons.format_list_bulleted_add,
        color: AppColors.grey,
      ),
      label: 'Add Task',
    ),
    const BottomNavigationBarItem(
      activeIcon: Icon(
        Icons.person,
        color: AppColors.deepPurple,
      ),
      icon: Icon(
        Icons.person,
        color: AppColors.grey,
      ),
      label: 'Profile',
    ),
  ];

  final List<Widget> screens = [
    const Homeview(),
    const ProjectTaskView(),
    const AddTaskView(),
    const Profileview(),
  ];

  void onItemTapped(int index) {
    selectedIndex = index;
    emit(ChangeBottomNavBarState());
  }
}
