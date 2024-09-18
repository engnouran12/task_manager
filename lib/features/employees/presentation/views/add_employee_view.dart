

import 'package:flutter/material.dart';
import 'package:task_manager/features/employees/presentation/views/widget/add_employee_body.dart';

class AddEmployeeView extends StatelessWidget {
  const AddEmployeeView({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body:AddEmployeeBody() ,
    );
  }
}
