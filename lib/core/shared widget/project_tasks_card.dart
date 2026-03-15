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

  Color statusColor(String? status) {
    if (widget.task.done == true) return Colors.green;
    switch (status) {
      case 'NotStarted': return Colors.grey;
      case 'InProgress': return Colors.blue;
      case 'Completed': return Colors.green;
      case 'Failed': return Colors.red;
      case 'Deferred': return Colors.orange;
      case 'Pending': return Colors.yellow.shade700;
      default: return Colors.blue; // Default for in progress
    }
  }

  Future<void> _updateTaskStatus(bool done, String note) async {
    setState(() {
      widget.task.done = done;
    });
    // In a real app we would pass the note to the API.
    await AddTaskCubit.get(context).patchtask(done, token!, widget.task.id ?? '', widget.projectId);
    if (context.mounted) {
      await _projectTaskCubit.changeProjectStatuse(context, widget.projectId);
    }
    if (widget.onChanged != null) {
      widget.onChanged!(done);
    }
  }

  void _showQuickCompleteSheet(BuildContext context, bool value) {
    final TextEditingController noteController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quick Complete', style: AppStyles.stylebold24(context)),
              const SizedBox(height: 16),
              Text(widget.task.name, style: AppStyles.styleMedium14(context)),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Optional completion note',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _updateTaskStatus(true, noteController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Mark Complete', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
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
                Text( ' ${widget.task.date.difference(DateTime.now()).inDays} Days '),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor(widget.task.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.task.done == true ? 'Completed' : (widget.task.status ?? 'InProgress'),
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor(widget.task.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            value: widget.task.done,
            onChanged: (bool? value) async {
              if (value != null && value == true) {
                _showQuickCompleteSheet(context, value);
              } else if (value != null) {
                _updateTaskStatus(false, '');
              }
            },
          );
        },
      ),
    );
  }
}
