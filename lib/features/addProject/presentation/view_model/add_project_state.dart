import 'package:task_manager/core/models/projects/project_model.dart';

abstract class AddProjectState {}

class AddProjectIntialState extends AddProjectState {}

class LoadingAddProjectState extends AddProjectState {}
class AddProjectSuccessfullyState extends AddProjectState {}
class AddProjectFailureState extends AddProjectState {
  final String error;
  AddProjectFailureState(this.error);
}

class AddProjectChangePriorityState extends AddProjectState {}
class AddProjectChangeManagerState extends AddProjectState {}
class AddProjectChangeEmployeesState extends AddProjectState {}

class LoadingGetAllProjectsState extends AddProjectState {}
class GetAllProjectsSuccessfullyState extends AddProjectState {
  final List<ProjectModel> projects;
  GetAllProjectsSuccessfullyState(this.projects);
}
class GetAllProjectsFailureState extends AddProjectState {
  final String error;
  GetAllProjectsFailureState(this.error);
}

class LoadingFindProjectByIdState extends AddProjectState {}
class FindProjectByIdSuccessfullyState extends AddProjectState {
  final ProjectModel project;
  FindProjectByIdSuccessfullyState(this.project);
}
class FindProjectByIdFailureState extends AddProjectState {
  final String error;
  FindProjectByIdFailureState(this.error);
}

class LoadingFindProjectByNameState extends AddProjectState {}
class FindProjectByNameSuccessfullyState extends AddProjectState {
  final ProjectModel project;
  FindProjectByNameSuccessfullyState(this.project);
}
class FindProjectByNameFailureState extends AddProjectState {
  final String error;
  FindProjectByNameFailureState(this.error);
}
