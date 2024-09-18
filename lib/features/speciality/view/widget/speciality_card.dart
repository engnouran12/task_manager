import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/Speciality/speciality_model.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_cubit.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_state.dart';
import 'package:task_manager/features/speciality/view/widget/employees_speciality_body.dart';

class SpecialityCard extends StatelessWidget {
  final Speciality specialty;
  const SpecialityCard({super.key, required this.specialty});

  @override
  Widget build(BuildContext context) {
    return
      BlocBuilder<EmployeesCubit, EmployeesState>(
       builder: (context, state) {
         if (state is EmployeesLoadingState) {
           return const Center(child: CircularProgressIndicator());
         } else if (state is EmployeesLoadedState) {
           final employees = state.employees?.where((employee) {
             return employee.specialityId.name == specialty.name;
           }).toList() ?? [];
           return  InkWell(
             onTap: (){
               Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (builder) =>
                       EmployeesSpecialityBody(specialty:specialty,),
                 ),
               );
             },
             child: Container(
               height: responsiveComponantSize(context, 90),
               width: screenWidth(context),
               decoration: BoxDecoration(
                   border: Border.all(color:AppColors.greyWhite ),
                   color: AppColors.white,
                   borderRadius: BorderRadius.circular(8)),
               child: ListTile(
                   title: Text(
                     specialty.name,
                     style: AppStyles.styleSemiBold20(context)
                         .copyWith(color: AppColors.deepPurple),
                   ),
                   subtitle: Text(
                     'Employee Number: ${employees.length} ',
                     style: AppStyles.styleMedium14(context)
                         .copyWith(fontSize: responsiveComponantSize(context, 12), color: AppColors.moreGrey),
                   ),
                   trailing: IconButton(
                     onPressed: () {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                           builder: (builder) =>
                               EmployeesSpecialityBody(specialty:specialty,),
                         ),
                       );
                     },
                     icon: const Icon(Icons.more_vert,
                       color:AppColors.black,
                     ),
                   )),
             ),
           ) ;
         }
         else if (state is EmployeesErrorState) {
           return Center(
               child: Text(ErrorHandling.handleError(state.error)));
         }else{
           return const Center(child: Text('logIn failed'));
         }
       }

          );
  }
}
