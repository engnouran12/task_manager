import 'package:flutter/material.dart';
import 'package:task_manager/features/projectDetails/presentation/views/widget/tasks_view_body.dart';

class TaskView extends StatelessWidget {
  final String projectid;
  const TaskView({super.key, required this.projectid});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: TasksViewBody(projectid: projectid,),
      ),
    );
  }
}
