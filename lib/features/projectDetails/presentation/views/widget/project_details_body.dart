import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/mock/mock_data.dart';
import 'package:task_manager/core/models/projects/project_model.dart';
import 'package:task_manager/core/models/task/task_model.dart';
import 'package:task_manager/core/shared%20widget/overview_card.dart';
import 'package:task_manager/core/shared%20widget/team_member_card.dart';
import 'package:task_manager/core/shared%20widget/urgent_card.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/projectDetails/presentation/views/task_detail_view.dart';

/// Fully static project detail body — no API or Bloc.
class ProjectDetailsBody extends StatelessWidget {
  final String projectId;
  final double? value;
  const ProjectDetailsBody({super.key, required this.projectId, this.value});

  @override
  Widget build(BuildContext context) {
    final ProjectModel? project = MockData.projectById(projectId);
    final double progress = MockData.projectProgress[projectId] ?? 0.0;
    final List<TaskModel> tasks = MockData.tasksForProject(projectId);

    if (project == null) {
      return const Center(child: Text('Project not found'));
    }

    return CustomScrollView(
      slivers: [
        // ── App bar row ───────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: responsiveComponantSize(context, 24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: responsiveComponantSize(context, 16)),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.greyWhite),
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.darkPurple),
                        onPressed: () => Navigator.pop(context),
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
                SizedBox(height: responsiveComponantSize(context, 20)),

                // ── Project card ──────────────────────────────────────
                UrgentProjectCard(
                  project: project,
                  progress: progress,
                  status: project.status ?? 'todo',
                ),
                SizedBox(height: responsiveComponantSize(context, 16)),

                // ── Overview ──────────────────────────────────────────
                OverViewCard(description: project.description),
                SizedBox(height: responsiveComponantSize(context, 16)),

                // ── Priority & due date chips ─────────────────────────
                Wrap(
                  spacing: 8,
                  children: [
                    _Chip(
                      icon: Icons.flag_outlined,
                      label: MockData.priorityLabel(project.priority),
                    ),
                    _Chip(
                      icon: Icons.calendar_today_outlined,
                      label:
                          'Due ${_formatDate(project.dueDate)}',
                    ),
                  ],
                ),
                SizedBox(height: responsiveComponantSize(context, 16)),

                // ── Tasks header ──────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tasks (${tasks.length})',
                        style: AppStyles.styleSemiBold14(context)),
                    Text(
                      'See All',
                      style: AppStyles.styleMedium14(context)
                          .copyWith(color: AppColors.deepPurple),
                    ),
                  ],
                ),
                SizedBox(height: responsiveComponantSize(context, 8)),
              ],
            ),
          ),
        ),

        // ── Task list ─────────────────────────────────────────────────
        SliverPadding(
          padding: EdgeInsets.symmetric(
              horizontal: responsiveComponantSize(context, 24)),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final task = tasks[index];
                return _TaskTile(task: task, projectId: projectId);
              },
              childCount: tasks.length,
            ),
          ),
        ),

        // ── Team members ──────────────────────────────────────────────
        SliverToBoxAdapter(
          child: SizedBox(height: responsiveComponantSize(context, 16)),
        ),
        const SliverToBoxAdapter(child: AllemployeesCard()),
        SliverToBoxAdapter(
          child: SizedBox(height: responsiveComponantSize(context, 24)),
        ),
      ],
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day}/${d.month}/${d.year}';
}

// ─────────────────────────────────────────────────────────────────────────────
// Small chip widget
// ─────────────────────────────────────────────────────────────────────────────
class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.greyWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.darkPurple),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.darkPurple)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Task tile that navigates to task detail
// ─────────────────────────────────────────────────────────────────────────────
class _TaskTile extends StatelessWidget {
  final TaskModel task;
  final String projectId;
  const _TaskTile({required this.task, required this.projectId});

  Color get _priorityColor {
    switch (task.priority) {
      case 'high':
        return Colors.red.shade100;
      case 'medium':
        return Colors.orange.shade100;
      default:
        return Colors.green.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailView(task: task),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.greyWhite),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Done indicator
            Icon(
              task.done == true
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: task.done == true
                  ? const Color(0xff388E3C)
                  : AppColors.grey,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.name,
                      style: AppStyles.styleSemiBold14(context).copyWith(
                        decoration: task.done == true
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.done == true
                            ? AppColors.grey
                            : AppColors.darkPurple,
                      )),
                  const SizedBox(height: 2),
                  Text(
                    task.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.styleRegular12(context)
                        .copyWith(color: AppColors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Priority badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _priorityColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                task.priority,
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
