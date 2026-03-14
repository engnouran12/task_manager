import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';

// Base state class
abstract class ModifyEmployeeState {}

// Initial state when the cubit is first created
class ModifyEmployeesInitialState extends ModifyEmployeeState {}

// State when data is being loaded
class ModifyEmployeesLoadingState extends ModifyEmployeeState {}

// State when employee data is successfully loaded
class ModifyEmployeesLoadedState extends ModifyEmployeeState {
  final List<EmployeeData>? employees; // Null safety: employees can be null
  final EmployeeData? employee; // Null safety: single employee can be null

  ModifyEmployeesLoadedState({this.employees, this.employee});
}

// State when an operation is successful
class ModifyEmployeesSuccessState extends ModifyEmployeeState {
  final String message;

  ModifyEmployeesSuccessState(this.message);
}

// State when an error occurs
class ModifyEmployeesErrorState extends ModifyEmployeeState {
  final String error;

  ModifyEmployeesErrorState(String? error) : error = error ?? 'Unknown error';
}