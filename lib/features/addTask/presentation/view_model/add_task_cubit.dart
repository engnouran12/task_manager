import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/models/task/task_model.dart';
import 'package:task_manager/core/services/remote_repo/admin/tasks/task.dart'; // Import your TasksService
import 'package:task_manager/features/addTask/presentation/view_model/add_task_state.dart';


class AddTaskCubit extends Cubit<AddTaskState> {
  final TasksService tasksService;
  AddTaskCubit({required this.tasksService}) : super(AddTaskInitialState());

  // void settaskservices(TaskServices taskservices) {
  //   _taskServices = taskservices;
  // }

  static AddTaskCubit get(context) => BlocProvider.of(context);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedProjectid = '';
  String? selectedEmployeetid = '';

  List<String> priority = ['high', 'medium', 'low'];
  String selectedTaskPriority = 'low'; // Default priority



  void changePriority(int index) {
    selectedTaskPriority = priority[index];
    emit(AddTaskChangePriorityState());
  }

Future<void> patchtask(bool taskstate, String token,String taskId,String projectId) async {
    emit(AddTaskLoadingState());
    try {
      await tasksService.patchTaskStatus(token, taskId, taskstate);
      emit(AddTaskTogleState(taskstate));
      await getAllTaskByProject(token,projectId);
    } catch (e) {
      emit(AddTaskErrorState(e.toString()));
    }
  }
  Future<void> addTask(TaskModel taskData, String token) async {
    emit(AddTaskLoadingState());
    try {
      await tasksService.addTask(taskData, token);
      emit(AddTaskSuccessState("Task added successfully"));
      // Optionally, you can also clear the form or navigate to another screen
    } catch (e) {
      emit(AddTaskErrorState(e.toString()));
    }
  }

  // Add other methods as needed for fetching or editing tasks

  // Example of a method to fetch a task by ID
  Future<void> getTaskById(String id, String token) async {
    emit(AddTaskLoadingState());
    try {
      final task = await tasksService.getTaskById(id, token);
      emit(AddTaskLoadedState(task: task));
    } catch (e) {
      emit(AddTaskErrorState(e.toString()));
    }
  }

  Future<List<TaskModel>> getAllTask(String token) async {
    emit(AddTaskLoadingState());
    try {
      final task = await tasksService.getAllTasks(token);

      emit(AddTaskLoadedListState(task: task));
      return task;

    } catch (e) {
      emit(AddTaskErrorState(e.toString()));
      return [];
    }
  }

  Future<List<TaskModel>> getAllTaskByProject(
      String token, String projectid) async {
    emit(AddTaskLoadingState());
    try {
      final task = await tasksService.getTaskByProject(projectid, token);

      emit(AddTaskLoadedListState(task: task));
      return task;
    } catch (e) {
      emit(AddTaskErrorState(e.toString()));
      return [];
    }
  }

  Future<void> editTask(String id, TaskModel taskData, String token) async {
    emit(AddTaskLoadingState());
    try {
      await tasksService.editTask(id, taskData, token);
      emit(AddTaskSuccessState("Task updated successfully"));
      // Optionally, you can also clear the form or navigate to another screen
    } catch (e) {
      emit(AddTaskErrorState(e.toString()));
    }
  }

  Future<void> deleteTask(String id, String token) async {
    emit(AddTaskLoadingState());
    try {
      await tasksService.deleteTask(id, token);
      emit(AddTaskSuccessState("Task deleted successfully"));
      // Optionally, you can refresh the task list or navigate to another screen
    } catch (e) {
      emit(AddTaskErrorState(e.toString()));
    }
  }
}
