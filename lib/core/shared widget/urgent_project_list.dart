import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart'; // Import Skeletonizer
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/projects/project_model.dart';
import 'package:task_manager/core/models/task/task_model.dart';
import 'package:task_manager/core/shared%20widget/urgent_card.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/features/addTask/presentation/view_model/add_task_cubit.dart';
import 'package:task_manager/features/projectDetails/presentation/views/project_details_view.dart';
import 'package:task_manager/features/projectTask/presentation/view_model/project_task_cubit.dart';
import 'package:task_manager/features/projectTask/presentation/view_model/project_task_state.dart';

class UrgentProjectList extends StatefulWidget {
  const UrgentProjectList({super.key});

  @override
  _UrgentProjectListState createState() => _UrgentProjectListState();
}

class _UrgentProjectListState extends State<UrgentProjectList> {
  @override
  void initState() {
    super.initState();
    initdata();
  }

  initdata() async {
    await fetchdata();
  }

  fetchdata() async {
    role == 'employee'
        ? await context.read<ProjectTaskCubit>().getAllProjectTask()
        : await context.read<ProjectTaskCubit>().findProjectByEmployee(id!);
  }

  Future<double> getAllData(String projectId) async {
    var taskCubit = AddTaskCubit.get(context);
    var projectCubit = ProjectTaskCubit.get(context);
    final List<TaskModel> tasks =
        await taskCubit.getAllTaskByProject(token!, projectId);
    final double progress = projectCubit.calculateProgress(tasks);
    return progress;
  }

  @override
  Widget build(BuildContext context) {
    return role == 'employee'
        ? BlocBuilder<ProjectTaskCubit, ProjectTaskState>(
            builder: (context, state) {
              return Skeletonizer(
                enabled: state is ProjectTaskLoadingState,
                child: _buildList(
                    state,
                    state is ProjectTaskLoadedState
                        ? state.projectForEmployee
                                ?.where((project) => project.hidden == false)
                                .toList() ?? []
                        : []),
              );
            },
          )
        : BlocBuilder<ProjectTaskCubit, ProjectTaskState>(
            builder: (context, state) {
              return Skeletonizer(
                enabled: state is ProjectTaskLoadingState,
                child: _buildList(
                    state,
                    state is ProjectTaskLoadedState
                        ? state.projectTasks
                                ?.where((project) => project.hidden == false)
                                .toList() ?? []
                        : []),
              );
            },
          );
  }

  Widget _buildList(ProjectTaskState state, List<ProjectModel> projectTasks) {
    if (state is ProjectTaskErrorState) {
      return Center(child: Text(ErrorHandling.handleError(state.error)));
    }

    if (projectTasks.isEmpty && state is ProjectTaskLoadedState) {
      return const Center(child: Text('No projects found'));
    }

    return SizedBox(
      height: projectTasks.length * (screenHeight(context) / 6),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: projectTasks.length,
        itemBuilder: (context, index) {
          final projectTask = projectTasks[index];
          return Dismissible(
            key: Key(projectTask.id!), // Unique key for each item
            background: Container(
              color: AppColors.deepPurple,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: responsiveComponantSize(context, 16)),
                  child: const Icon(Icons.delete, color: Colors.black),
                ),
              ),
            ),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              context.read<ProjectTaskCubit>().deleteProject(projectTask.id!);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: responsiveComponantSize(context, 24)),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProjectDetailsView(projectId: projectTask.id!),
                    ),
                  );
                },
                child: FutureBuilder<double>(
                  future: getAllData(projectTask.id!),
                  builder: (context, snapshot) {
                    return Skeletonizer(
                      enabled: !snapshot.hasData,
                      child: snapshot.hasError
                          ? const Text('Error fetching progress')
                          : UrgentProjectCard(
                              project: projectTask,
                              status: projectTask.status!,
                              progress: snapshot.data ?? 0.0,
                            ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
