import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/projects/project_model.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/projectTask/presentation/view/project_task_view.dart';
import 'package:task_manager/features/projectTask/presentation/view/widget/project_task_body.dart';
import 'package:task_manager/features/projectTask/presentation/view_model/project_task_cubit.dart';
import 'package:task_manager/features/projectTask/presentation/view_model/project_task_state.dart';

import '../../../../../core/services/remote_repo/admin/projects/project.dart';

class ProjectCard extends StatefulWidget {
  final String title;

  const ProjectCard({super.key, required this.title});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  final ProjectServices projectServices = ProjectServices();

  @override
  void initState() {
    super.initState();
    if (context.read<ProjectTaskCubit>().state is! ProjectTaskLoadedState) {
      role == 'employee'
          ? context.read<ProjectTaskCubit>().findProjectByEmployee(id!)
          : context.read<ProjectTaskCubit>().getAllProjectTask();
    }
  }

  IconData _getIconForTitle(String title) {
    final Map<String, IconData> titleIcons = {
      'todo': Icons.pending_actions,
      'inprogress': Icons.incomplete_circle,
      'completed': Icons.check_circle,
      'holding': Icons.pause_circle_filled,
    };
    return titleIcons[title] ?? Icons.pending_actions;
  }

  Widget _buildSkeletonCard(BuildContext context) {
    return SizedBox(
      height: 180.h, // Use ScreenUtil for height
      width: 170.w, // Use ScreenUtil for width
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.r), // Use responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Loading...', style: AppStyles.styleSemiBold14(context)),
              SizedBox(height: 8.h), // Use ScreenUtil for spacing
              Text('0 Tasks',
                  style: AppStyles.styleRegular12(context)
                      .copyWith(color: AppColors.grey)),
              SizedBox(height: 16.h),
              const Skeleton.shade(
                child: Icon(Icons.pending_actions_outlined),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: Row(
                  children: [
                    Text('View All Tasks',
                        style: AppStyles.styleSemiBold12(context)),
                    SizedBox(width: 8.w), // Use ScreenUtil for width
                    Skeleton.shade(
                      child: Icon(
                        size: 12.sp, // Use ScreenUtil for icon size
                        Icons.arrow_forward_ios,
                        color: AppColors.darkPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProjectCard(
      ProjectTaskState state, List<ProjectModel>? allProjectTasks) {
    if (state is ProjectTaskLoadingState) {
      return Skeletonizer(
        enabled: true,
        child: _buildSkeletonCard(context),
      );
    } else if (state is ProjectTaskLoadedState) {
      List<ProjectModel> filteredProjectTasks = (widget.title == 'holding')
          ? (allProjectTasks
                  ?.where((project) => project.hidden == true)
                  .toList() ??
              [])
          : (allProjectTasks?.where((project) {
                return project.hidden == false &&
                    project.status == widget.title;
              }).toList() ??
              []);

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => 
              const ProjectTaskView(),
            ),
          );
        },
        child: SizedBox(
          height: 180.h,
          width: 170.w,
          child: Card(
            color: AppColors.white,
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: AppStyles.styleSemiBold14(context)),
                  SizedBox(height: 4.h),
                  Text('${filteredProjectTasks.length} Tasks',
                      style: AppStyles.styleRegular12(context)
                          .copyWith(color: AppColors.grey)),
                  SizedBox(height: 16.h),
                  Icon(
                    _getIconForTitle(widget.title),
                    size: 30.sp, // Use ScreenUtil for icon size
                    color: AppColors.deepPurple,
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: Row(
                      children: [
                        Text('View All Tasks',
                            style: AppStyles.styleSemiBold12(context)),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProjectTaskView(),
                                ),
                              );
                            },
                            icon: Icon(
                              size: 12.sp,
                              Icons.arrow_forward_ios,
                              color: AppColors.darkPurple,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (state is ProjectTaskErrorState) {
      return Padding(
        padding: EdgeInsets.all(15.r),
        child: Center(child: Text(ErrorHandling.handleError(state.error))),
      );
    } else {
      return const Center(child: Text('No projects found'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectTaskCubit, ProjectTaskState>(
      builder: (context, state) {
        List<ProjectModel>? allProjectTasks = role == 'employee'
            ? (state is ProjectTaskLoadedState
                ? state.projectForEmployee
                : null)
            : (state is ProjectTaskLoadedState ? state.projectTasks : null);

        return buildProjectCard(state, allProjectTasks);
      },
    );
  }
}
