import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/shared%20widget/project_tasks_card.dart';
import 'package:task_manager/features/addTask/presentation/view_model/add_task_cubit.dart';
import 'package:task_manager/features/addTask/presentation/view_model/add_task_state.dart';

class ProjectTaskList extends StatefulWidget {
  final String projectId;
  final bool? status;

  const ProjectTaskList({super.key, 
  required this.projectId, this.status,});

  @override
  State<ProjectTaskList> createState() => _ProjectTaskListState();
}

class _ProjectTaskListState extends State<ProjectTaskList> {
  @override
  void initState() {
    super.initState();
    AddTaskCubit.get(context).getAllTaskByProject(token!, widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTaskCubit, AddTaskState>(
      builder: (context, state) {
        if (state is AddTaskLoadingState) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is AddTaskLoadedListState) {
          final tasks = state.task;
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding:  EdgeInsets.only(top: responsiveComponantSize(context, 16)),
                  child: ProjectTaskCard(
                      task: tasks[index],
                      onChanged: (p0) async {},
                    projectId: widget.projectId,),
                );
              },
              childCount: tasks.length, // Set childCount
            ),
          );
        }
        if (state is AddTaskErrorState) {
          return const SliverToBoxAdapter(
            child: Center(child: Text('Failed to load tasks')),
          );
        }
        return const SliverToBoxAdapter(
          child: Center(child: Text('No tasks yet')),
        );
      },
    );
  }
}
