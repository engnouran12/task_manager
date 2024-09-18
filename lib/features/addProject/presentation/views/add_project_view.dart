import 'package:flutter/material.dart';
import 'package:task_manager/features/addProject/presentation/views/widgets/add_project_body.dart';

class AddProjectView extends StatelessWidget {
  const AddProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AddProjectBody(),
    );
  }
}