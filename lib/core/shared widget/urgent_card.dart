import 'package:flutter/material.dart';
import 'package:task_manager/core/models/projects/project_model.dart';
import 'package:task_manager/core/models/task/task_model.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';

import '../constant/constant.dart';

class UrgentProjectCard extends StatefulWidget {
  final ProjectModel project;

  double progress = 0.0;
  String status = 'to do'; // Default status

  UrgentProjectCard({super.key, required this.project,
   required this.progress , this.status='to do'});

  @override
  State<UrgentProjectCard> createState() => _UrgentProjectCardState();
}

class _UrgentProjectCardState extends State<UrgentProjectCard> {
  List<TaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context) / 7,
      width: screenWidth(context),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyWhite),
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12, left: 16, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.project.name,
                    style: AppStyles.styleSemiBold14(context)),
                const SizedBox(width: 5),
                const Icon(Icons.trending_up),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.status,
                    style: AppStyles.styleRegular12(context)), // Display status
                Text(
                  '${(widget.progress * 100).toInt()}%',
                  style: AppStyles.styleRegular12(context),
                ),
              ],
            ),
            const SizedBox(height: 5),
            LinearProgressIndicator(
              value: widget.progress,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time_filled,
                        size: responsiveComponantSize(context, 24),
                        color: AppColors.deepPurple,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ' ${widget.project.dueDate.difference(DateTime.now()).inDays} Days left',
                        style: AppStyles.styleRegular12(context)
                            .copyWith(color: AppColors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'View Task',
                        style: AppStyles.styleRegular12(context),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          size: screenWidth(context) / 25,
                          Icons.arrow_forward_ios,
                          color: AppColors.deepPurple,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
