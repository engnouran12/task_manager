// ignore: file_names


import 'package:flutter/material.dart';
import 'package:task_manager/features/projectTask/presentation/view/widget/project_task_body.dart';

class ProjectTaskView extends StatelessWidget {
  const ProjectTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return  const SafeArea(
      child: Scaffold(
        body: ProjectTaskBody(),
      ),
    );
  }
}
