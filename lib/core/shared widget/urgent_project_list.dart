import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/mock/mock_data.dart';
import 'package:task_manager/core/models/projects/project_model.dart';
import 'package:task_manager/core/shared%20widget/urgent_card.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/features/projectDetails/presentation/views/project_details_view.dart';

/// Fully static replacement for UrgentProjectList — no API or Bloc needed.
class UrgentProjectList extends StatelessWidget {
  const UrgentProjectList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ProjectModel> visibleProjects =
        MockData.projects.where((p) => p.hidden == false).toList();

    return SizedBox(
      height: visibleProjects.length * (screenHeight(context) / 6),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: visibleProjects.length,
        itemBuilder: (context, index) {
          final project = visibleProjects[index];
          final progress = MockData.projectProgress[project.id] ?? 0.0;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ProjectDetailsView(projectId: project.id!),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsiveComponantSize(context, 24),
              ),
              child: UrgentProjectCard(
                project: project,
                status: project.status ?? 'todo',
                progress: progress,
              ),
            ),
          );
        },
      ),
    );
  }
}
