import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';

abstract class ProfileInfoState {}
class ProfileInfoIntialState extends ProfileInfoState {}

class ProfileInfoLoadingState extends ProfileInfoState {}


// State when employee data is successfully loaded
class ProfileInfoLoadedState extends ProfileInfoState {
  final List<EmployeeData>? employees; // Null safety: employees can be null
  final EmployeeData? employee; // Null safety: single employee can be null

  ProfileInfoLoadedState({this.employees, this.employee});
}

// State when an operation is successful
class ProfileInfoSuccessState extends ProfileInfoState {
  final String message;

  ProfileInfoSuccessState(this.message);
}

// State when an error occurs
class ProfileInfoErrorState extends ProfileInfoState {
  final String error;

  ProfileInfoErrorState(String? error) : error = error ?? 'Unknown error';
}