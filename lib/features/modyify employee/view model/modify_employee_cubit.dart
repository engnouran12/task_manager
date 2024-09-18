import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/modyify%20employee/view%20model/modify_employee_state.dart';

class ModifyEmployeeCubit extends Cubit<ModifyEmployeeState> {

  ModifyEmployeeCubit() : super(ModifyEmployeesInitialState());

  static ModifyEmployeeCubit get(context) => BlocProvider.of(context);
  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController addressController = TextEditingController();



}