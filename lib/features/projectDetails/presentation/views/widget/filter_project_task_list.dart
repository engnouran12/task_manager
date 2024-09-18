import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/task/task_model.dart';
import 'package:task_manager/core/shared%20widget/project_tasks_card.dart';
import 'package:task_manager/features/addTask/presentation/view_model/add_task_cubit.dart';
import 'package:task_manager/features/addTask/presentation/view_model/add_task_state.dart';

class FilterProjectTaskList extends StatelessWidget {
  final bool status;
  final String projectid;
  const FilterProjectTaskList({super.key, required this.status, required this.projectid});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTaskCubit, AddTaskState>(
      builder: (context, state) {
        if (state is AddTaskLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AddTaskLoadedListState) {
          // Filter tasks based on the `done` status
          final List<TaskModel> filteredTasks =
              state.task.where((task) => task.done == status).toList();

          if (filteredTasks.isEmpty) {
            return const Center(child: Text('No tasks found'));
          }

          return ListView.builder(
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              return ProjectTaskCard(
                task: filteredTasks[index], projectId: projectid,
              );
            },
          );
        } else if (state is AddTaskErrorState) {
          return Center(
              child: Text(ErrorHandling.handleError(state.error)));
        } else {
          return const Center(child: Text('No tasks yet'));
        }
      },
    );
  }
}
