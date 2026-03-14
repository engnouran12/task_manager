import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';

class ProjectManagerSelectionCard extends StatelessWidget {
  final EmployeeData employee;
  final bool isSelected;
  final void Function() onTap; // Callback to handle selection

  const ProjectManagerSelectionCard({
    super.key,
    required this.employee,
    required this.isSelected,
    required this.onTap,
  });
  final String baseUrl = 'http://66.29.130.92:5070/';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: responsiveComponantSize(context, 90),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColors.deepPurple : AppColors.greyWhite,
        ),
        color: isSelected ? AppColors.moreLightPurple : AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: employee.img != null
            ? CircleAvatar(
          radius: responsiveComponantSize(context, 30),
          backgroundImage: NetworkImage('$baseUrl${employee.img!}'),
        )
            : null,
        title: Text(
          '${employee.firstName} ${employee.secondName}',
          style: AppStyles.styleSemiBold14(context)
              .copyWith(fontSize: responsiveComponantSize(context, 16), color: AppColors.black),
        ),
        subtitle: Text(
          employee.specialityId.name,
          style:isSelected?AppStyles.styleSemiBold14(context)
              .copyWith( color: AppColors.black) :AppStyles.styleMedium14(context),
        ),
        onTap: onTap,
      ),
    );
  }
}
