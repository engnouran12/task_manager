import 'package:task_manager/core/models/projects/project_model.dart';

abstract class ProjectTaskState {}

class ProjectTaskIntialState extends ProjectTaskState {}

class ProjectTaskLoadingState extends ProjectTaskState {}

class ProjectTaskChangeIndexState extends ProjectTaskState {}

// State when employee data is successfully loaded
class ProjectTaskLoadedState extends ProjectTaskState {
  final List<ProjectModel>?
      projectTasks; // Null safety: ProjectTask can be null
  final ProjectModel? projectTask; // Null safety: single employee can be null
  final List<ProjectModel>? projectForEmployee; // Null safety: single employee can be null

  ProjectTaskLoadedState({this.projectTasks, this.projectTask,this.projectForEmployee});
}

// State when an operation is successful
class ProjectTaskSuccessState extends ProjectTaskState {
  final String message;

  ProjectTaskSuccessState(this.message);
}

class FilterProjectState extends ProjectTaskState {
   String status='todo';
final  List<ProjectModel> filterlist;

  FilterProjectState(this.filterlist);
}

// State when an error occurs
class ProjectTaskErrorState extends ProjectTaskState {
  final String error;

  ProjectTaskErrorState(String? error) : error = error ?? 'Unknown error';
}
