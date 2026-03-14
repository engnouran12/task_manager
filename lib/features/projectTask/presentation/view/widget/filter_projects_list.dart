import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/mock/mock_data.dart';
import 'package:task_manager/core/models/projects/project_model.dart';
import 'package:task_manager/core/shared%20widget/urgent_card.dart';
import 'package:task_manager/features/projectDetails/presentation/views/project_details_view.dart';

/// Fully static — shows mock projects filtered by status, no API / Bloc.
class FilterProjectsList extends StatelessWidget {
  final String status;
  const FilterProjectsList({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final List<ProjectModel> filtered = MockData.projectsByStatus(status);

    if (filtered.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No projects found',
              style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final project = filtered[index];
        final progress = MockData.projectProgress[project.id] ?? 0.0;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProjectDetailsView(projectId: project.id!),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.only(
              bottom: responsiveComponantSize(context, 8),
            ),
            child: UrgentProjectCard(
              project: project,
              status: project.status ?? status,
              progress: progress,
            ),
          ),
        );
      },
    );
  }
}
