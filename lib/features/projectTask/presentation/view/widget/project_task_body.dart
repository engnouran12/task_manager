import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/projects/project_model.dart';
import 'package:task_manager/core/services/remote_repo/admin/projects/project.dart';
import 'package:task_manager/core/shared%20widget/custom_search_bar.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/features/addProject/presentation/views/add_project_view.dart';
import 'package:task_manager/features/projectTask/presentation/view/widget/project_state.dart';
import 'package:task_manager/features/projectTask/presentation/view_model/project_task_cubit.dart';
import 'package:task_manager/features/projectTask/presentation/view_model/project_task_state.dart';
import 'package:task_manager/features/projectTask/presentation/view_model/tap_cubit.dart';

class ProjectTaskBody extends StatefulWidget {
  final String? status;
  const ProjectTaskBody({super.key, this.value, this.status});

  final double? value;

  @override
  State<ProjectTaskBody> createState() => _ProjectTaskBodyState();
}

class _ProjectTaskBodyState extends State<ProjectTaskBody> {
  @override
  void initState() {
    super.initState();
    if (role == 'employee') {
      context.read<ProjectTaskCubit>().findProjectByEmployee(id!);
    } else {
      context.read<ProjectTaskCubit>().getAllProjectTask();
    }
  }

  Future<void> _refreshProjectTasks() async {
    context.read<ProjectTaskCubit>().getAllProjectTask();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabCubit, int>(
      builder: (context, selectedIndex) {
        final tabStatus = _getStatusFromIndex(selectedIndex);
        ProjectTaskState state = ProjectTaskLoadedState();
        return RefreshIndicator(
          onRefresh: _refreshProjectTasks,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsiveComponantSize(context, 24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: responsiveComponantSize(context, 24)),
                  _buildProjectList(tabStatus,state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: CustomSearchBar(hinttext: 'Search Project.... '),
        ),
        SizedBox(width: responsiveComponantSize(context, 8)),
        if (role != 'employee')
          Container(
            height: screenHeight(context) / 17,
            width: screenWidth(context) / 9,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: AppColors.white,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddProjectView()),
                );
                _refreshProjectTasks();
              },
              icon: const Icon(
                Icons.note_add_outlined,
                color: AppColors.deepPurple,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProjectList(String tabStatus, ProjectTaskState state) {
    return Skeletonizer(
      enabled: state is ProjectTaskLoadingState,
      child: _buildProjectListContent(state, tabStatus),
    );
  }

  Widget _buildProjectListContent(ProjectTaskState state, String tabStatus) {
    if (state is ProjectTaskErrorState) {
      return Center(child: Text(ErrorHandling.handleError(state.error)));
    }

    List<ProjectModel> allProjectTasks = [];
    if (state is ProjectTaskLoadedState) {
      allProjectTasks = role == 'employee'
          ? state.projectForEmployee ?? []
          : state.projectTasks ?? [];
    }

    final filteredProjectTasks = (tabStatus == 'holding')
        ? allProjectTasks.where((project) => project.hidden == true).toList()
        : allProjectTasks
            .where((project) =>
                project.hidden == false && project.status == tabStatus)
            .toList();

    return SizedBox(
      height: filteredProjectTasks.isEmpty
          ? responsiveComponantSize(context, 200)
          : (filteredProjectTasks.length) * (screenHeight(context) / 5) + 80,
      width: screenWidth(context),
      child: filteredProjectTasks.isEmpty
          ? const Center(child: Text('No projects Found'))
          : ProjectState(status: widget.status),
    );
  }

  String _getStatusFromIndex(int index) {
    switch (index) {
      case 0:
        return 'todo';
      case 1:
        return 'inprogress';
      case 2:
        return 'completed';
      case 3:
        return 'holding';
      default:
        return 'todo';
    }
  }
}
