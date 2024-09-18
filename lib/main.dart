import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/core/helper/dependencies.dart';
import 'package:task_manager/features/addProject/presentation/view_model/add_project_cubit.dart';
import 'package:task_manager/features/addTask/presentation/view_model/add_task_cubit.dart';
import 'package:task_manager/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_cubit.dart';
import 'package:task_manager/features/home/presentation/view_model/bottom_nav_bar_cubit.dart';
import 'package:task_manager/features/home/presentation/view_model/bottom_nav_employee_cubit.dart';
import 'package:task_manager/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:task_manager/features/profileInfo/presentation/view_model/profile_info_cubit.dart';
import 'package:task_manager/features/projectTask/presentation/view_model/project_task_cubit.dart';
import 'package:task_manager/features/projectTask/presentation/view_model/tap_cubit.dart';
import 'package:task_manager/features/speciality/view_model/speciality_cubit.dart';
import 'package:task_manager/features/splashScren/presentation/views/spalsh_view.dart';

import 'core/constant/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  // SecureSharedPref pref = await SecureSharedPref.getInstance();
  // final LocalRepo locale= LocalRepo(secureSharedPreferences: pref);
  // token = await locale.getToken();
  // id = await locale.getString('id');
  // role=await locale.getString('role');

  await setupServiceLocator();

  runApp(ScreenUtilInit(
      designSize: const Size(427, 926),
      builder: (comtext, child) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => getIt<AddTaskCubit>()),
        BlocProvider(create: (_) => getIt<EmployeesCubit>()),
        BlocProvider(create: (_) => getIt<AddProjectCubit>()),
        BlocProvider(create: (_) => getIt<BottomNavBarCubit>()),
        BlocProvider(create: (_) => getIt<ProfileCubit>()),
        BlocProvider(create: (_) => getIt<ProfileInfoCubit>()),
        BlocProvider(create: (_) => getIt<ProjectTaskCubit>()),
        BlocProvider(create: (_) => getIt<SpecialtyCubit>()),
        BlocProvider(create: (_) => getIt<TabCubit>()),
        BlocProvider(create: (_) => getIt<BottomNavEmployeeCubit>()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const SplashView()),
    );
  }
}
