import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';

// Base state class
abstract class EmployeesState {}

// Initial state when the cubit is first created
class EmployeesInitialState extends EmployeesState {}

// State when data is being loaded
class EmployeesLoadingState extends EmployeesState {}

// State when employee data is successfully loaded
class EmployeesLoadedState extends EmployeesState {
  final List<EmployeeData>? employees; // Null safety: employees can be null
  final EmployeeData? employee; // Null safety: single employee can be null

  EmployeesLoadedState({this.employees, this.employee});
}

// State when an operation is successful
class EmployeesSuccessState extends EmployeesState {
  final String message;

  EmployeesSuccessState(this.message);
}

// State when an error occurs
class EmployeesErrorState extends EmployeesState {
  final String error;

  EmployeesErrorState(String? error) : error = error ?? 'Unknown error';
}