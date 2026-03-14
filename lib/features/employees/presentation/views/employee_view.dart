
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_cubit.dart';
import 'package:task_manager/features/employees/presentation/views/widget/add_employee_body.dart';
import 'package:task_manager/features/employees/presentation/views/widget/employees_body.dart';

class EmployeesView extends StatelessWidget {
  const EmployeesView({super.key,  this.projectEmployees});
final List<EmployeeData>?projectEmployees;
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        floatingActionButton:role!='employee'&&projectEmployees==null? FloatingActionButton(
          backgroundColor: AppColors.deepPurple,
          onPressed: (){
            Navigator.push(
                context, MaterialPageRoute(builder: (builder)=> const AddEmployeeBody()
            ));
            context.read<EmployeesCubit>().getEmployeeById(id!);
          },
          child: const Icon(Icons.person_add_alt_1,color: AppColors.white,size: 30,),
        )
        :null,
        body:  EmployeesBody(projectEmployees: projectEmployees,),
      ),
    );
  }
}
