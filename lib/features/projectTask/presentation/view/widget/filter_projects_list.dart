import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class FilterProjectsList extends StatefulWidget {
  final String status;
  const FilterProjectsList({super.key, required this.status});

  @override
  State<FilterProjectsList> createState() => _FilterProjectsListState();
}

class _FilterProjectsListState extends State<FilterProjectsList> {
  @override
  void initState() {
    super.initState();
  }

  Future<double> getAllData(String projectId) async {
    var taskCubit = AddTaskCubit.get(context);
    var projectCubit = ProjectTaskCubit.get(context);
    final List<TaskModel> tasks = await taskCubit.getAllTaskByProject(token!, projectId);
    final double progress = projectCubit.calculateProgress(tasks);
    return progress;
  }

  @override
  Widget build(BuildContext context) {
    return role=='employee'
        ? BlocBuilder<ProjectTaskCubit, ProjectTaskState>(
      builder: (context, state) {
        var cubit = ProjectTaskCubit.get(context);
        if (state is ProjectTaskLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProjectTaskLoadedState) {
          List<ProjectModel>? allProjectTasks = state.projectForEmployee;
          List<ProjectModel> filteredProjectTasks = (widget.status == 'holding')
              ? (allProjectTasks?.where((projectForEmployee) => projectForEmployee.hidden == true).toList() ?? [])
              : (allProjectTasks?.where((projectForEmployee) {
            return projectForEmployee.hidden == false && projectForEmployee.status == widget.status;
          }).toList() ?? []);

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredProjectTasks.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectDetailsView(
                        projectId: filteredProjectTasks[index].id!,
                      ),
                    ),
                  );
                },
                child: Dismissible(
                  key: Key(filteredProjectTasks[index].id!), // Unique key for each item
                  background: Container(
                    color: AppColors.deepPurple,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: responsiveComponantSize(context, 16)),
                        child: const Icon(Icons.delete, color: AppColors.black),
                      ),
                    ),
                  ),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    // Handle deletion
                    cubit.deleteProject(filteredProjectTasks[index].id!);
                  },
                  child: FutureBuilder<double>(
                    future: getAllData(filteredProjectTasks[index].id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Text('Error fetching progress');
                      } else {
                        double progress = snapshot.data ?? 0.0;
                        return UrgentProjectCard(
                          project: filteredProjectTasks[index],
                          status: widget.status,
                          progress: progress,
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        } else if (state is ProjectTaskErrorState) {
          return Center(
              child: Text(ErrorHandling.handleError(state.error)));
        } else {
          return const Center(child: Text('No projects Found'));
        }
      },
    )
        :BlocBuilder<ProjectTaskCubit, ProjectTaskState>(
      builder: (context, state) {
        var cubit = ProjectTaskCubit.get(context);
        if (state is ProjectTaskLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProjectTaskLoadedState) {
          List<ProjectModel>? allProjectTasks = state.projectTasks;
          List<ProjectModel> filteredProjectTasks = (widget.status == 'holding')
              ? (allProjectTasks?.where((projectTask) => projectTask.hidden == true).toList() ?? [])
              : (allProjectTasks?.where((projectTask) {
            return projectTask.hidden == false && projectTask.status == widget.status;
          }).toList() ?? []);

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredProjectTasks.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectDetailsView(
                        projectId: filteredProjectTasks[index].id!,
                      ),
                    ),
                  );
                },
                child: Dismissible(
                  key: Key(filteredProjectTasks[index].id!), // Unique key for each item
                  background: Container(
                    color: AppColors.deepPurple,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: responsiveComponantSize(context, 16)),
                        child: const Icon(Icons.delete, color: AppColors.black),
                      ),
                    ),
                  ),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    // Handle deletion
                    cubit.deleteProject(filteredProjectTasks[index].id!);
                  },
                  child: FutureBuilder<double>(
                    future: getAllData(filteredProjectTasks[index].id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error fetching progress');
                      } else {
                        double progress = snapshot.data ?? 0.0;
                        return UrgentProjectCard(
                          project: filteredProjectTasks[index],
                          status: widget.status,
                          progress: progress,
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        } else if (state is ProjectTaskErrorState) {
          return Center(
              child: Text(ErrorHandling.handleError(state.error)));
        } else {
          return const Center(child: Text('No projects Found'));
        }
      },
    );
  }
}
