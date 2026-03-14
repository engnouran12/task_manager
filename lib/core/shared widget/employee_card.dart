import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';


class EmployeeCard extends StatefulWidget {
  final EmployeeData employee;
  const EmployeeCard({super.key, required this.employee});

  @override
  State<EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  bool isselected = false;
   String baseUrl = 'http://66.29.130.92:5070/';
  @override
  Widget build(BuildContext context) {
    return Container(
      height: responsiveComponantSize(context, 90),
      width: screenWidth(context),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyWhite),
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8)),
      child:ListTile(
        leading : widget.employee.img != null
            ?  CircleAvatar(
          radius: responsiveComponantSize(context, 30),
          backgroundImage: NetworkImage('$baseUrl${widget.employee.img!}'),
        )
            :  CircleAvatar(
          radius: responsiveComponantSize(context, 30),
          backgroundColor: AppColors.greyWhite,
          child: const Icon(
            Icons.person,
            color: AppColors.grey,
          ),
        ),
        title: Text(
          '${widget.employee.firstName} ${widget.employee.secondName}',
          style: AppStyles.styleSemiBold14(context)
              .copyWith(fontSize: responsiveComponantSize(context, 16), color: AppColors.black),
        ),
        subtitle: Text(
          widget.employee.specialityId.name,
          style: AppStyles.styleMedium14(context),
        ),
      )
    );
  }
}
