

import 'package:flutter/material.dart';
import 'package:task_manager/features/addTask/presentation/views/widget/add_task_body.dart';

class AddTaskView extends StatelessWidget {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: AddTaskBody(),
      ),
    );
  }
}
