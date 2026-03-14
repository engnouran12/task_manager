
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/services/local/shared_data.dart';
import 'package:task_manager/core/services/remote_repo/admin/admin_services.dart';
import 'package:task_manager/core/services/remote_repo/admin/employees/employee.dart';
import 'package:task_manager/core/services/remote_repo/admin/projects/project.dart';
import 'package:task_manager/core/services/remote_repo/admin/spacilitys/spacility.dart';
import 'package:task_manager/core/services/remote_repo/admin/tasks/task.dart';
import 'package:task_manager/core/services/remote_repo/auth.dart';
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


final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
   final SharedPreferences preferences = await SharedPreferences.getInstance();

  getIt.registerLazySingleton(() => 
  LocalRepo(sharedPreferences: preferences));

  // Register LocalRepo after SecureSharedPref is ready

  // Register other services
  getIt.registerLazySingleton(() => TasksService());
  getIt.registerLazySingleton(() => AdminService());
  getIt.registerLazySingleton(() => AuthService());
   getIt.registerLazySingleton(() => EmployeeServices());
   getIt.registerLazySingleton(() => ProjectServices());
   getIt.registerLazySingleton(() => SpecialityServices());

  // Register Cubits
  getIt.registerFactory(() => AddTaskCubit(
    tasksService: getIt<TasksService>()));
  getIt.registerFactory(() => AuthCubit(
    locale: 
    getIt<LocalRepo>(),
    authService: 
    getIt<AuthService>(),
  ));
   getIt.registerFactory(() => EmployeesCubit(getIt<EmployeeServices>()));
   getIt.registerFactory(() => AddProjectCubit(getIt<ProjectServices>()));
   getIt.registerFactory(() => BottomNavBarCubit());
   getIt.registerFactory(() => TabCubit());
   getIt.registerFactory(() => BottomNavEmployeeCubit());
   getIt.registerFactory(() => ProfileCubit(getIt<EmployeeServices>()));
   getIt.registerFactory(() => ProfileInfoCubit(getIt<EmployeeServices>()));
   getIt.registerFactory(() => ProjectTaskCubit(getIt<ProjectServices>(),

   getIt<AddTaskCubit>()
   ));
   getIt.registerFactory(() => SpecialtyCubit(getIt<SpecialityServices>()));





   await getIt.allReady();
}
