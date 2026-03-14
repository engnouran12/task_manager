import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/shared%20widget/custom_search_bar.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/speciality/view/specialty_view.dart';

import 'employee_list.dart';

class EmployeesBody extends StatelessWidget {
  const EmployeesBody({super.key, this.projectEmployees});
  final List<EmployeeData>?projectEmployees;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.symmetric(
          horizontal: responsiveComponantSize(context, 24),
          vertical: responsiveComponantSize(context, 22)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyWhite),
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.darkPurple,
                  ),
                  onPressed: () {
                    Navigator.pop(context,true);
                  },
                ),
              ),
              Center(
                child: Text(
                  'Employees',
                  style: AppStyles.stylebold24(context)
                      .copyWith(color: AppColors.darkPurple),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyWhite),
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.brush,
                    color: AppColors.darkPurple,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(
                        builder: (builder)=> SpecialtyView()
                    ));
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: responsiveComponantSize(context, 16)),
          const CustomSearchBar(hinttext: 'Search Employee.... '),
          SizedBox(height: responsiveComponantSize(context, 16)),
           Expanded(child: EmployeeList(projectEmployees: projectEmployees,)),  // Use Expanded to fill available space
        ],
      ),
    );
  }
}