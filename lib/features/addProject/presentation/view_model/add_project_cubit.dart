import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/projects/project_model.dart';
import 'package:task_manager/core/services/remote_repo/admin/projects/project.dart';
import 'package:task_manager/features/addProject/presentation/view_model/add_project_state.dart';

class AddProjectCubit extends Cubit<AddProjectState> {
  final ProjectServices _projectServices;

  AddProjectCubit(this._projectServices) : super(AddProjectIntialState());

  static AddProjectCubit get(context) => BlocProvider.of(context);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedProjectPriority = 'low'; // Initialize with a default value
  String? selectedprojectManager = '';
  List<String> priority = [
    'high',
    'medium',
    'low',
  ];

  void changePriority(int index) {
    selectedProjectPriority = priority[index];
    emit(AddProjectChangePriorityState());
  }

  void addProject(BuildContext context, project) async {
    emit(LoadingAddProjectState());


    try {
      await _projectServices.addproject(project);
      if (!isClosed) {
        // Check if the Cubit is still open
        emit(AddProjectSuccessfullyState());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('add project successfully')),
        );
      }
      Navigator.pop(context);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const ProjectTaskView()),
      // );
    } catch (e) {
      if (!isClosed) {
        // Check if the Cubit is still open
        emit(AddProjectFailureState(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ErrorHandling.handleError(e.toString()))),
        );
      }
    }
  }

  void setManagerId(String managerId) {
    selectedprojectManager = managerId;
    emit(AddProjectChangeManagerState());
  }

  void addEmployee(String employeeId) {
    selectedEmployees.add(employeeId);
    emit(AddProjectChangeEmployeesState());
  }

  void removeEmployee(String employeeId) {
    selectedEmployees.remove(employeeId);
    emit(AddProjectChangeEmployeesState());
  }

  Future<List<ProjectModel>> getAllProjects() async {
    emit(LoadingGetAllProjectsState());
    try {
      final projects = await _projectServices.getAllProjects();

      emit(GetAllProjectsSuccessfullyState(projects.cast<ProjectModel>()));
      return projects;
    } catch (e) {
      emit(GetAllProjectsFailureState(e.toString()));
      return [];
    }
  }

  Future<ProjectModel> findProjectById(String id) async {
    emit(LoadingFindProjectByIdState());
    try {
      // Call your service to get the project data
      final project = await _projectServices.findProjectById(id);
      emit(FindProjectByIdSuccessfullyState(project));
      return project;
    } catch (e) {
      emit(FindProjectByIdFailureState(e.toString()));
      // Rethrow the error or handle it according to your requirements
      throw e;
    }
  }

  Future<void> findProjectByName(String name) async {
    emit(LoadingFindProjectByNameState());
    try {
      final project = await _projectServices.findProjectByName(name);
      emit(FindProjectByNameSuccessfullyState(project));
    } catch (e) {
      emit(FindProjectByNameFailureState(e.toString()));
    }
  }


}
