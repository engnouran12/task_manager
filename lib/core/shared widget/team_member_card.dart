import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/mock/mock_data.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';

/// Fully static team-members card — no API or Bloc needed.
class AllemployeesCard extends StatelessWidget {
  const AllemployeesCard({super.key, this.projectEmployeeId});

  final List<String>? projectEmployeeId;

  @override
  Widget build(BuildContext context) {
    final employees = MockData.employees;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsiveComponantSize(context, 24),
      ),
      child: Container(
        width: screenWidth(context),
        margin:
            EdgeInsets.only(bottom: responsiveComponantSize(context, 15)),
        padding: EdgeInsets.all(responsiveComponantSize(context, 16)),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyWhite),
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Team Members',
                    style: AppStyles.styleSemiBold14(context)),
                Text(
                  'See All',
                  style: AppStyles.styleMedium14(context)
                      .copyWith(color: AppColors.moreLightPurple),
                ),
              ],
            ),
            SizedBox(height: responsiveComponantSize(context, 12)),
            // Avatar row
            SizedBox(
              height: responsiveComponantSize(context, 45),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                    employees.length > 6 ? 7 : employees.length,
                itemBuilder: (context, index) {
                  // "+N" overflow avatar
                  if (index == 6 && employees.length > 6) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: CircleAvatar(
                        radius: responsiveComponantSize(context, 22),
                        backgroundColor: AppColors.greyWhite,
                        child: Text(
                          '+${employees.length - 6}',
                          style: AppStyles.styleSemiBold12(context)
                              .copyWith(color: AppColors.darkPurple),
                        ),
                      ),
                    );
                  }
                  final emp = employees[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Tooltip(
                      message: emp['name']!,
                      child: CircleAvatar(
                        radius: responsiveComponantSize(context, 22),
                        backgroundColor:
                            Color(int.parse(emp['color']!)),
                        child: Text(
                          emp['initials']!,
                          style: AppStyles.styleSemiBold12(context)
                              .copyWith(
                                  color: AppColors.white,
                                  fontSize:
                                      responsiveComponantSize(context, 12)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
