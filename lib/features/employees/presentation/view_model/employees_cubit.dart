import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/employee/employee.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/services/remote_repo/admin/employees/employee.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_state.dart';

class EmployeesCubit extends Cubit<EmployeesState> {
  final EmployeeServices _employeeServices;
  EmployeesCubit(this._employeeServices) : super(EmployeesInitialState());

  static EmployeesCubit get(context) => BlocProvider.of(context);

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Future<void> addEmployee(Employee employeeData ,BuildContext context) async {
    emit(EmployeesLoadingState());
    try {
      await _employeeServices.addEmployee(employeeData);
      if (!isClosed) {
        emit(EmployeesSuccessState("Employee added successfully"));
        await getAllEmployees(); // Optionally refresh the employee list
        Navigator.pop(context);
      }
    } catch (e) {
      if (!isClosed) {
        emit(EmployeesErrorState(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandling.handleError(e.toString()))),
        );
      }
    }
  }
// TODO here you can cache the data in your EmployeesCubit so that the data is not fetched repeatedly if it's already available
  Future<void> getEmployeeById(String id) async {
    emit(EmployeesLoadingState());
    try {
      final employee = await _employeeServices.getEmployeeById(id);
      // Debug line
      if (!isClosed) {
        emit(EmployeesLoadedState(employee: employee));
      }
    } catch (e) {
      if (!isClosed) {
        emit(EmployeesErrorState(e.toString()));
      }
    }
  }

  Future<List<EmployeeData>> getAllEmployees() async {
    emit(EmployeesLoadingState());
    try {
      final employees = await _employeeServices.getAllEmployees();
      if (!isClosed) {
        emit(EmployeesLoadedState(employees: employees));
        return employees;
      }
    } catch (e) {
      if (!isClosed) {
        emit(EmployeesErrorState(e.toString()));
        return [];
      }
    }
    return [];
  }

  Future<void> editEmployee(String id, EmployeeData employeeData,BuildContext context) async {
    emit(EmployeesLoadingState());
    try {
      await _employeeServices.editEmployee(id, employeeData);
      emit(EmployeesSuccessState("Employee updated successfully"));
      await getEmployeeById(id);
      Navigator.pop(context, true);
      // }
    } catch (e) {
      emit(EmployeesErrorState(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorHandling.handleError(e.toString()))),
      );
    }
  }

  Future<void> deleteEmployee(String id) async {
    emit(EmployeesLoadingState());
    try {
      await _employeeServices.deleteEmployee(id);
      // if (!isClosed) {
      emit(EmployeesSuccessState("Employee deleted successfully"));
      await getAllEmployees();
      // }
    } catch (e) {
      if (!isClosed) {
        emit(EmployeesErrorState(e.toString()));
      }
    }
  }
}

