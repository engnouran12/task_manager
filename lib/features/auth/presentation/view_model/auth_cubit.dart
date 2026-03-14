import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/services/local/shared_data.dart';
import 'package:task_manager/core/services/remote_repo/auth.dart';
import 'package:task_manager/features/auth/presentation/view_model/auth_state.dart';
import 'package:task_manager/features/home/presentation/view/wiget/bottom_bar_admin.dart';
import 'package:task_manager/features/home/presentation/view/wiget/bottom_nav.dart';

class AuthCubit extends Cubit<AuthState> {
  final LocalRepo locale;
  final AuthService authService;

  AuthCubit({required this.locale, required this.authService})
      : super(AuthIntialState());
  static AuthCubit get(context) => BlocProvider.of(context);

  bool obsecure = true;
  // final LocalRepo localdata;
  void changeobsecure() {
    obsecure = !obsecure;
    emit(ChangeobsecureState());
  }

  bool? isChecked = false;
  void changeCheckedStates(value) {
    isChecked = value;
    emit(ChangeCheckedStatesState());
  }

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    emit(LogInLoadingState());
    String email = emailController.text;
    String password = passwordController.text;
    try {
      // SecureSharedPref pref = await SecureSharedPref.getInstance();
      // AuthService authService = AuthService();

      Map<String, dynamic> response = await authService.login(email, password);
      if (response.containsKey('token') &&
          response.containsKey('employee') &&
          response['employee'] is Map<String, dynamic>) {
        try {
          // Ensure 'token' is a String
          EmployeeData employee = EmployeeData.fromMap(
              response['employee'] as Map<String, dynamic>);
          authEmployeeId = employee.id!;
          await locale.addToken(response['token']);
          await locale.putBool('isLogIn', true);
          await locale.putString('id', employee.id!);
          await locale.putString('role', employee.role!);
          role=employee.role!;
          id =employee.id!;
          token= response['token'];
          if (employee.role == 'admin') {
            emit(LogInSuccessState());
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavigationBarAdmin(),
              ),
            );
          } else {
            emit(LogInSuccessState());
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavigationBarUser(),
              ),
            );
          }
        } catch (e) {
          emit(LogInFailedState());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${ErrorHandling.handleError(e.toString())}')),
          );
        }
      } else {
        emit(LogInFailedState());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed')),
        );
      }
    } catch (e) {
      emit(LogInFailedState());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorHandling.handleError(e.toString()))),
      );
    }
  }
}
