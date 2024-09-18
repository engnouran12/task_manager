import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/services/remote_repo/admin/employees/employee.dart';
import 'package:task_manager/core/services/remote_repo/auth.dart';
import 'package:task_manager/core/services/remote_repo/upload_image.dart';
import 'package:task_manager/features/profile/presentation/view_model/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final EmployeeServices _employeeServices;
  ProfileCubit(this._employeeServices,) : super(ProfileIntialState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  final ImageUploadService _imageUploadService = ImageUploadService();
  late String imagePath;


  bool result = false;
  Future<void> logout(BuildContext context) async {
    AuthService authService = AuthService();

    try {
      // Ensure the token is not null before calling logout
      if (token == null) {
        throw Exception('No authorization token available');
      }
      await authService.logout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('logging out Successfully')),
      );
    } catch (error) {
      // Handle error in setting preference

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorHandling.handleError(error as String))),
      );
    }
  }


  Future<void> getEmployeeById(String id) async {
    emit(ProfileLoadingState());
    try {
      final employee = await _employeeServices.getEmployeeById(id);
      emit(ProfileLoadedState(employee: employee));
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }

  Future<void> editEmployee(String id, EmployeeData employeeData, BuildContext context) async {
    emit(ProfileLoadingState());
    try {
      await _employeeServices.editEmployee(id, employeeData);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit Employee Successfully')));
      await getEmployeeById(id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorHandling.handleError(e.toString()))),
      );
      print('Error editing image: $e');
      emit(ProfileErrorState(e.toString()));
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    // Pick an image
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      try {
        Map<String, dynamic> response = await _imageUploadService.uploadImage(imageFile);
        if (response.containsKey('path')) {
          imagePath = response['path'];
          await getEmployeeById(id!);
          print('Image uploaded successfully: ${response['path']}');
        } else {
          throw Exception('Image path missing in response');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandling.handleError(e.toString()))),
        );
        emit(ProfileErrorState(e.toString()));
      }
    }

  }
}
