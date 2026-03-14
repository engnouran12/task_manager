import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/mock/mock_data.dart';
import 'package:task_manager/core/models/projects/project_model.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/projectTask/presentation/view/project_task_view.dart';

class ProjectCard extends StatelessWidget {
  final String title;

  const ProjectCard({super.key, required this.title});

  IconData _getIconForTitle(String t) {
    const map = {
      'todo': Icons.pending_actions,
      'inprogress': Icons.incomplete_circle,
      'completed': Icons.check_circle,
      'holding': Icons.pause_circle_filled,
    };
    return map[t] ?? Icons.pending_actions;
  }

  Color _getColorForTitle(String t) {
    const map = {
      'todo': AppColors.moreLightPurple,
      'inprogress': AppColors.deepPurple,
      'completed': Color(0xff388E3C),
      'holding': Color(0xffF57C00),
    };
    return map[t] ?? AppColors.deepPurple;
  }

  @override
  Widget build(BuildContext context) {
    final List<ProjectModel> filtered = title == 'holding'
        ? MockData.projects.where((p) => p.hidden == true).toList()
        : MockData.projects
            .where((p) => p.hidden == false && p.status == title)
            .toList();

    final color = _getColorForTitle(title);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProjectTaskView(initialStatus: title),
          ),
        );
      },
      child: SizedBox(
        height: 180.h,
        width: 170.w,
        child: Card(
          elevation: 2,
          color: AppColors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    title,
                    style: AppStyles.styleSemiBold12(context)
                        .copyWith(color: color),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  '${filtered.length} Projects',
                  style: AppStyles.styleRegular12(context)
                      .copyWith(color: AppColors.grey),
                ),
                SizedBox(height: 12.h),
                Icon(
                  _getIconForTitle(title),
                  size: 28.sp,
                  color: color,
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      'View All',
                      style: AppStyles.styleSemiBold12(context)
                          .copyWith(color: color),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.arrow_forward_ios, size: 11.sp, color: color),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

