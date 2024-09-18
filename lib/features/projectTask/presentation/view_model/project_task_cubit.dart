
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/projects/project_model.dart';
import 'package:task_manager/core/models/task/task_model.dart';
import 'package:task_manager/core/services/remote_repo/admin/projects/project.dart';
import 'package:task_manager/features/addTask/presentation/view_model/add_task_cubit.dart';
import 'package:task_manager/features/projectTask/presentation/view_model/project_task_state.dart';


class ProjectTaskCubit extends Cubit<ProjectTaskState> {
  final ProjectServices projectTaskervices;
  final AddTaskCubit addTaskCubit;
  ProjectTaskCubit(this.projectTaskervices, this.addTaskCubit) : super(ProjectTaskIntialState());

  static ProjectTaskCubit get(context) => BlocProvider.of(context);
  String status = 'todo';
  bool _isLoading = false;
  late ProjectModel originalProject;

  void changeTab(int index) {
    emit(ProjectTaskChangeIndexState());
  }


   Future<void> loadProjects(String status) async {
    if (_isLoading) return; // Prevent multiple loads

    _isLoading = true;
    emit(ProjectTaskLoadingState());

    try {
      List<ProjectModel> allProjects = await getAllProjectTask();
      List<ProjectModel> filteredProjects = [];

      for (var project in allProjects) {
        final tasks = await addTaskCubit.getAllTaskByProject(token!, project.id!);
        double progress = calculateProgress(tasks);
        String projectStatus = determineStatus(progress);
        project.status = projectStatus;

        if (projectStatus == status) {
          filteredProjects.add(project);
        }
      }

      emit(FilterProjectState(filteredProjects));
    } catch (e) {
      emit(ProjectTaskErrorState(e.toString()));
    } finally {
      _isLoading = false;
    }
  }
  //calculate progress
  double calculateProgress(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return 0.0;
    }
    int completedTasks = tasks.where((task) => task.done!).length;
    double progressValue =completedTasks / tasks.length;
    return progressValue;
  }
  //change project status
  Future<void> changeProjectStatuse(BuildContext context,String selectedProjectid)async{
    try{
      final List<TaskModel> tasks = await addTaskCubit.getAllTaskByProject(token!, selectedProjectid);
      final Iterable<TaskModel> completedTasks = tasks.where((task) => task.done!);
      if (tasks.length==completedTasks.length){
        originalProject = await getProjectById(selectedProjectid);

        // Update the project status
        final updatedProject = originalProject.copyWith(status: 'completed');

        // Update the project in the ProjectTaskCubit
        await editProject(selectedProjectid, updatedProject, context);
      }else if(tasks.isNotEmpty&&tasks.length!=completedTasks.length){
        // Fetch the original project (awaiting the Future)
        originalProject = await getProjectById(selectedProjectid);

        // Update the project status
        final updatedProject = originalProject.copyWith(status: 'inprogress');

        // Update the project in the ProjectTaskCubit
        await editProject(selectedProjectid, updatedProject, context);
      }

    }catch(e){
      emit(ProjectTaskErrorState(e.toString()));
    }
  }
  String determineStatus(double progress) {
    if (progress == 1.0) {
      return 'completed';
    } else if (progress == 0.0) {
      return 'todo';
    } else {
      return 'inprogress';
    }
  }

  Future<void> addProject(ProjectModel projectData) async {
    emit(ProjectTaskLoadingState());
    try {
      await projectTaskervices.addproject(projectData);
      emit(ProjectTaskSuccessState("Project added successfully"));
      await getAllProjectTask(); // Optionally refresh the Project list
    } catch (e) {
      emit(ProjectTaskErrorState(e.toString()));
    }
  }

  Future<ProjectModel> getProjectById(String id) async {
    emit(ProjectTaskLoadingState());
    try {
      final project = await projectTaskervices.findProjectById(id);
      emit(ProjectTaskLoadedState(projectTask: project));
      return project;

    } catch (e) {
      emit(ProjectTaskErrorState(e.toString()));
      rethrow;

    }
  }
// TODO here you can cache the data in your EmployeesCubit so that the data is not fetched repeatedly if it's already available in all get data methods
  Future<List<ProjectModel>> getAllProjectTask() async {
    emit(ProjectTaskLoadingState());
    try {
      final projectTasks = await projectTaskervices.getAllProjects();

      emit(ProjectTaskLoadedState(projectTasks: projectTasks));
      return projectTasks;
    } catch (e) {
      emit(ProjectTaskErrorState(e.toString()));
      return [];
    }
  }

  Future<void> editProject(String id, ProjectModel projectData, context) async {
    emit(ProjectTaskLoadingState());
    try {
      await projectTaskervices.editProject(id, projectData);
      emit(ProjectTaskSuccessState("Project updated successfully"));
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Edit Project Successfully')));
      await getProjectById(id);

      // Optionally refresh the Project list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorHandling.handleError(e as String))),
      );
      emit(ProjectTaskErrorState(e.toString()));
    }
  }

  Future<void> deleteProject(String id) async {
    emit(ProjectTaskLoadingState());
    try {
      await projectTaskervices.deleteProject(id);
      emit(ProjectTaskSuccessState("Project deleted successfully"));
      await getAllProjectTask(); // Optionally refresh the Project list
    } catch (e) {
      emit(ProjectTaskErrorState(e.toString()));
    }
  }
  Future<List<ProjectModel>> findProjectByEmployee(String id) async {
    emit(ProjectTaskLoadingState());
    try {
      final List<ProjectModel> project = await projectTaskervices.findProjectByEmployee(id);
      emit(ProjectTaskLoadedState(projectForEmployee: project));
      return project;
    } catch (e) {
      emit(ProjectTaskErrorState(e.toString()));
      rethrow;
    }
  }

}
