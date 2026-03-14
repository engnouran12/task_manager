import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/shared%20widget/custom_search_bar.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/addProject/presentation/views/add_project_view.dart';
import 'package:task_manager/features/projectTask/presentation/view/widget/project_state.dart';

/// Fully static project-task body — no API or Bloc calls.
class ProjectTaskBody extends StatelessWidget {
  final String? status;
  final double? value;
  const ProjectTaskBody({super.key, this.value, this.status});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsiveComponantSize(context, 24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: responsiveComponantSize(context, 16)),
            // ── Header ──────────────────────────────────────────────
            Row(
              children: [
                const Expanded(
                  child: CustomSearchBar(hinttext: 'Search Project...'),
                ),
                SizedBox(width: responsiveComponantSize(context, 8)),
                Container(
                  height: screenHeight(context) / 17,
                  width: screenWidth(context) / 9,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: AppColors.white,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.note_add_outlined,
                      color: AppColors.deepPurple,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddProjectView(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: responsiveComponantSize(context, 24)),
            // ── Tab view (static) ───────────────────────────────────
            SizedBox(
              height: screenHeight(context) * 0.75,
              child: ProjectState(status: status),
            ),
          ],
        ),
      ),
    );
  }
}
