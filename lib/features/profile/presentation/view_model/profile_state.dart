import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';

abstract class ProfileState {}
class ProfileIntialState extends ProfileState {}
class ProfileLoadingState extends ProfileState {}


// State when employee data is successfully loaded
class ProfileLoadedState extends ProfileState {
  final List<EmployeeData>? employees; // Null safety: employees can be null
  final EmployeeData? employee; // Null safety: single employee can be null

  ProfileLoadedState({this.employees, this.employee});
}

// State when an operation is successful
class ProfileSuccessState extends ProfileState {
  final String message;

  ProfileSuccessState(this.message);
}

// State when an error occurs
class ProfileErrorState extends ProfileState {
  final String error;

  ProfileErrorState(String? error) : error = error ?? 'Unknown error';
}