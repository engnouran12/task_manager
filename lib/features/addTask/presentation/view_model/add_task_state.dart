import 'package:task_manager/core/models/task/task_model.dart';

// Base state class
abstract class AddTaskState {}

// Initial state when the cubit is first created
class AddTaskInitialState extends AddTaskState {}

// State when data is being loaded
class AddTaskLoadingState extends AddTaskState {}

// State when a task is successfully added or edited
class AddTaskSuccessState extends AddTaskState {
  final String message;

  AddTaskSuccessState(this.message);
}

// State when an error occurs
class AddTaskErrorState extends AddTaskState {
  final String error;

  AddTaskErrorState(this.error);
}
class AddTaskTogleState extends AddTaskState {
  final bool done;

  AddTaskTogleState(this.done);
}

// State when a task is loaded
class AddTaskLoadedState extends AddTaskState {
  final TaskModel task;

  AddTaskLoadedState({required this.task});
}
class AddTaskLoadedListState extends AddTaskState {
  final List<TaskModel> task;

  AddTaskLoadedListState({required this.task});
}

// State when priority changes
class AddTaskChangePriorityState extends AddTaskState {}
