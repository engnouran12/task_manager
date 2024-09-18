import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/task/task_model.dart';
import 'package:task_manager/core/shared%20widget/team_member_card.dart';
import 'package:task_manager/core/shared%20widget/urgent_card.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/core/shared%20widget/overview_card.dart';
import 'package:task_manager/core/shared%20widget/project_task_list.dart';
import 'package:task_manager/features/addTask/presentation/view_model/add_task_cubit.dart';
import 'package:task_manager/features/addTask/presentation/view_model/add_task_state.dart';
import 'package:task_manager/features/projectDetails/presentation/views/task_view.dart';
import 'package:task_manager/features/projectTask/presentation/view_model/project_task_cubit.dart';
import 'package:task_manager/features/projectTask/presentation/view_model/project_task_state.dart';

class ProjectDetailsBody extends StatefulWidget {
  final String projectId;
  final double? value;
  const ProjectDetailsBody({
    super.key,
    this.value,
    required this.projectId,
  });

  @override
  State<ProjectDetailsBody> createState() => _ProjectDetailsBodyState();
}

class _ProjectDetailsBodyState extends State<ProjectDetailsBody> {
  @override
  void initState() {
    super.initState();
    _initproject();
  }

  _initproject() async {
    await _getproject();
  }

  Future _getproject() async {
    role=='employee'
        ?await context.read<ProjectTaskCubit>().findProjectByEmployee(id!)
        :await context.read<ProjectTaskCubit>().getAllProjectTask();
    await context.read<ProjectTaskCubit>().getProjectById(widget.projectId);
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
    return WillPopScope(
      onWillPop: () async {
        role=='employee'
            ?context.read<ProjectTaskCubit>().findProjectByEmployee(id!)
            :context.read<ProjectTaskCubit>().getAllProjectTask();
        return true;
      },
      child: RefreshIndicator(
          onRefresh: _getproject,
          child: BlocListener<AddTaskCubit, AddTaskState>(
            listener: (context, state) async {
              if (state is AddTaskTogleState) {
                await context.read<ProjectTaskCubit>().getProjectById(widget.projectId);
              }
            },
            child: BlocBuilder<ProjectTaskCubit, ProjectTaskState>(
              builder: (context, state) {
                if (state is ProjectTaskLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProjectTaskLoadedState) {
                  final projectTask = state.projectTask;
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: responsiveComponantSize(context, 24)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: responsiveComponantSize(context, 15),
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColors.greyWhite),
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: AppColors.darkPurple,
                                      ),
                                      onPressed: () {
                                        role=='employee'
                                            ?context.read<ProjectTaskCubit>().findProjectByEmployee(id!)
                                            :context.read<ProjectTaskCubit>().getAllProjectTask();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'Project Details',
                                        style: AppStyles.stylebold24(context)
                                            .copyWith(color: AppColors.darkPurple),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: responsiveComponantSize(context, 28),
                              ),
                              FutureBuilder<double>(
                                future: getAllData(widget.projectId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return const Text('Error fetching progress');
                                  } else {
                                    double progress = snapshot.data ?? 0.0;
                                    return UrgentProjectCard(project: projectTask!,progress:progress,status: projectTask.status!,);
                                  }
                                },
                              ),
                              SizedBox(
                                height: responsiveComponantSize(context, 16),
                              ),
                              OverViewCard(
                                description: projectTask!.description,
                              ),
                              SizedBox(
                                height: responsiveComponantSize(context, 16),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tasks',
                                      style: AppStyles.styleSemiBold14(context)),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => TaskView(
                                                    projectid: widget.projectId,
                                                  )));
                                    },
                                    child: Text(
                                      //get all task in
                                      'See All',
                                      style: AppStyles.styleMedium14(context)
                                          .copyWith(color: AppColors.deepPurple),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                            horizontal: responsiveComponantSize(context, 24)),
                        sliver: ProjectTaskList(
                          projectId: widget.projectId,
                        ), // This should be a SliverList
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: responsiveComponantSize(context, 16),
                        ),
                      ),
                       SliverToBoxAdapter(child: AllemployeesCard(projectEmployeeId: projectTask.employees,)),
                    ],
                  );
                } else if (state is ProjectTaskErrorState) {
                  return Center(
                      child: Text(ErrorHandling.handleError(state.error)));
                } else {
                  return const Center(child: Text('No projects Found'));
                }
              },
            ),
          ),
      ),
    );
  }
}
