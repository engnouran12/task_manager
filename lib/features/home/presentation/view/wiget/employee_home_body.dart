import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/shared%20widget/custom_search_bar.dart';
import 'package:task_manager/core/shared%20widget/urgent_project_list.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/home/presentation/view/wiget/home_app_bar.dart';
import 'package:task_manager/features/home/presentation/view/wiget/quick_actions_group.dart';

class EmployeeHomeBody extends StatelessWidget {
  const EmployeeHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeAppBar(),
                SizedBox(height: responsiveComponantSize(context, 16)),
                const CustomSearchBar(hinttext: 'Search tasks...'),
                SizedBox(height: responsiveComponantSize(context, 24)),
                const QuickActionsGroup(),
                SizedBox(height: responsiveComponantSize(context, 24)),
                Text(
                  'My Active Tasks/Projects',
                  style: AppStyles.styleSemiBold20(context)
                      .copyWith(color: AppColors.darkPurple),
                ),
                SizedBox(height: responsiveComponantSize(context, 16)),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: UrgentProjectList()),
        SliverToBoxAdapter(
          child: SizedBox(height: responsiveComponantSize(context, 16)),
        ),
      ],
    );
  }
}
