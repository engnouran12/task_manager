import 'package:flutter/material.dart';
import 'package:task_manager/features/projectTask/presentation/view/widget/project_task_body.dart';

class ProjectTaskView extends StatelessWidget {
  /// Optional: pre-select the tab matching this status when opened.
  final String? initialStatus;
  const ProjectTaskView({super.key, this.initialStatus});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ProjectTaskBody(status: initialStatus),
      ),
    );
  }
}
