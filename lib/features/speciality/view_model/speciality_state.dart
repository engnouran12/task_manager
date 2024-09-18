import 'package:task_manager/core/models/Speciality/speciality_model.dart';

// Base state class
abstract class SpecialtysState {}

// Initial state when the cubit is first created
class SpecialtysInitialState extends SpecialtysState {}

// State when data is being loaded
class SpecialtysLoadingState extends SpecialtysState {}

// State when employee data is successfully loaded
class SpecialtysLoadedState extends SpecialtysState {
  late  List<Speciality>? specialtys; // Null safety: employees can be null
  late Speciality? specialty; // Null safety: single employee can be null

  SpecialtysLoadedState({this.specialtys, this.specialty});
}

// State when an operation is successful
class SpecialtysSuccessState extends SpecialtysState {
  final String message;

  SpecialtysSuccessState(this.message);
}

// State when an error occurs
class SpecialtysErrorState extends SpecialtysState {
  final String error;

  SpecialtysErrorState(String? error) : error = error ?? 'Unknown error';
}