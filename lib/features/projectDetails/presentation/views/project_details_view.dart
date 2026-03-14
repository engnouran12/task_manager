

import 'package:flutter/material.dart';
import 'package:task_manager/features/projectDetails/presentation/views/widget/project_details_body.dart';

class ProjectDetailsView extends StatelessWidget {
  final String projectId;
  const ProjectDetailsView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: ProjectDetailsBody(projectId:projectId),
      ),
    );
  }
}
