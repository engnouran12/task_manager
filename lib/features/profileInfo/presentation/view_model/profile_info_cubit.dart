import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/services/remote_repo/admin/employees/employee.dart';
import 'package:task_manager/features/profileInfo/presentation/view_model/profile_info_state.dart';

class ProfileInfoCubit extends Cubit<ProfileInfoState> {
  final EmployeeServices _employeeServices;
  ProfileInfoCubit(this._employeeServices) : super(ProfileInfoIntialState());
  static ProfileInfoCubit get(context) => BlocProvider.of(context);



  final TextEditingController fristnameController = TextEditingController();
  final TextEditingController secondnameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  bool isFristNameEdit = false;
  bool isSecondNameEdit = false;
  bool isPhoneEdit = false;


  void toggleEditMode(String field,originalEmployee) {
    switch (field) {
      case 'firstName':
        isFristNameEdit = !isFristNameEdit;
        emit(ProfileInfoLoadedState(employee: originalEmployee));  // To update the UI
        break;
      case 'secondName':
        isSecondNameEdit = !isSecondNameEdit;
        emit(ProfileInfoLoadedState(employee: originalEmployee));
        break;
      case 'phoneNumber':
        isPhoneEdit = !isPhoneEdit;
        emit(ProfileInfoLoadedState(employee: originalEmployee));
        break;
    }
  }
  Future<void> getEmployeeById(String id) async {
    emit(ProfileInfoLoadingState());
    try {
      final employee = await _employeeServices.getEmployeeById(id);

      emit(ProfileInfoLoadedState(employee: employee));

    } catch (e) {
      emit(ProfileInfoErrorState(e.toString()));
    }
  }
  Future<void> editEmployee(String id, EmployeeData employeeData,context) async {
    emit(ProfileInfoLoadingState());
    try {
      await _employeeServices.editEmployee(id, employeeData);
      emit(ProfileInfoSuccessState("Employee updated successfully"));
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit Employee Successfully')));
      await getEmployeeById(id);

      // Optionally refresh the employee list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorHandling.handleError(e.toString()))),
      );
      emit(ProfileInfoErrorState(e.toString()));
    }
  }
}

