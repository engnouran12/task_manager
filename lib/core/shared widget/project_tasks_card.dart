import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/models/task/task_model.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/addTask/presentation/view_model/add_task_cubit.dart';
import 'package:task_manager/features/projectTask/presentation/view_model/project_task_cubit.dart';
import 'package:task_manager/features/projectTask/presentation/view_model/project_task_state.dart';

class ProjectTaskCard extends StatefulWidget {
  final String projectId;
  final TaskModel task;
  final Function(bool?)? onChanged;
   const ProjectTaskCard({super.key, required this.task, this.onChanged, required this.projectId});

  @override
  State<ProjectTaskCard> createState() => _ProjectTaskCardState();
}

class _ProjectTaskCardState extends State<ProjectTaskCard> {
  late ProjectTaskCubit _projectTaskCubit;

  @override
  void initState() {
    super.initState();
    _projectTaskCubit = ProjectTaskCubit.get(context); // Cache the Cubit instance
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: responsiveComponantSize(context, 16)),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyWhite),
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8)),
      width: screenWidth(context),
      height: screenHeight(context) / 10,
      child: BlocConsumer<ProjectTaskCubit, ProjectTaskState>(
        listener: (context, state) {
          if (state is ProjectTaskSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ProjectTaskErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return CheckboxListTile(
            title: Text(
              widget.task.name,
              style: AppStyles.styleMedium14(context)
                  .copyWith(color: const Color(0xff101010)),
            ),
            subtitle: Row(
              children: [
               Icon(Icons.access_time_filled,
                 size: responsiveComponantSize(context, 24),
                 color: AppColors.deepPurple,
               ),
                //
                Text( ' ${widget.task.date.difference(DateTime.now()).inDays} Days left'),
              ],
            ),
            value: widget.task.done,
            onChanged: (bool? value)async {
              if (value != null) {
                // Update the task's done status locally
                setState(() {
                  widget.task.done = value;
                });

                // Use the AddTaskCubit to update
                // the task's status on the server
              await  AddTaskCubit.get(context)
                    .patchtask(value, token!, widget.task.id!,widget.projectId);
              // change project status
               await _projectTaskCubit.changeProjectStatuse(context,widget.projectId);

                // Call the optional onChanged callback
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              }
            },
          );
        },
      ),
    );
  }
}
