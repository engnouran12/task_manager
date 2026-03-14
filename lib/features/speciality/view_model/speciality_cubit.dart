import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/Speciality/speciality_model.dart';
import 'package:task_manager/core/services/remote_repo/admin/spacilitys/spacility.dart';
import 'package:task_manager/features/speciality/view_model/speciality_state.dart';

class SpecialtyCubit extends Cubit<SpecialtysState> {
  final SpecialityServices _specialtyServices;

  SpecialtyCubit(this._specialtyServices) : super(SpecialtysInitialState());

  static SpecialtyCubit get(context) => BlocProvider.of(context);

  Future<void> addSpeciality(Speciality speciality, BuildContext context) async {
    emit(SpecialtysLoadingState());
    try {
      await _specialtyServices.addSpeciality(speciality);
      await getAllSpecialtys();
    } catch (e) {
      // Log the full error details
      debugPrint('Error adding speciality: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorHandling.handleError(e as String))),
      );
      emit(SpecialtysErrorState(e.toString()));
    }
  }

  Future<void> getSpecialtyById(String id) async {
    emit(SpecialtysLoadingState());
    try {
      final specialty = await _specialtyServices.findSpecialityById(id);
      emit(SpecialtysLoadedState(specialty: specialty));

    } catch (e) {
      emit(SpecialtysErrorState(e.toString()));
    }
  }

  Future<void> getAllSpecialtys() async {
    emit(SpecialtysLoadingState());
    try {
      final specialtys = await _specialtyServices.getAllSpecialities();
      emit(SpecialtysLoadedState(specialtys: specialtys));
    } catch (e) {
      emit(SpecialtysErrorState(e.toString()));
    }
  }

}
