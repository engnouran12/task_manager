import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/mock/mock_data.dart';
import 'package:task_manager/core/models/task/task_model.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';

/// Static task detail screen — no API or Bloc.
class TaskDetailView extends StatefulWidget {
  final TaskModel task;
  const TaskDetailView({super.key, required this.task});

  @override
  State<TaskDetailView> createState() => _TaskDetailViewState();
}

class _TaskDetailViewState extends State<TaskDetailView> {
  late bool _done;
  late double _completionRate;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _done = widget.task.done ?? false;
    _completionRate = widget.task.completionRate ?? (_done ? 1.0 : 0.0);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSliderChanged(double value) {
    setState(() {
      _completionRate = value;
      if (value == 1.0) {
        _done = true;
      } else if (value == 0.0 && widget.task.done == true) {
        _done = false;
      }
    });

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // In a real app, you would dispatch a Bloc event here to patch completionRate
      debugPrint("API debounced call: Patching completionRate to $_completionRate");
    });
  }

  Color get _statusColor {
    if (_done || _completionRate == 1.0) return Colors.green;
    switch (widget.task.status) {
      case 'NotStarted': return Colors.grey;
      case 'InProgress': return Colors.blue;
      case 'Completed': return Colors.green;
      case 'Failed': return Colors.red;
      case 'Deferred': return Colors.orange;
      case 'Pending': return Colors.yellow.shade700;
      default: return Colors.blue;
    }
  }

  String get _statusText {
    if (_done || _completionRate == 1.0) return 'Completed';
    return widget.task.status ?? 'In Progress';
  }

  Color get _priorityColor {
    switch (widget.task.priority) {
      case 'high':
        return Colors.red.shade400;
      case 'medium':
        return Colors.orange.shade400;
      default:
        return Colors.green.shade500;
    }
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  Map<String, String>? get _assignee {
    try {
      return MockData.employees
          .firstWhere((e) => e['id'] == widget.task.employeeId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignee = _assignee;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF6F4FB),
        body: CustomScrollView(
          slivers: [
            // ── Header ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(responsiveComponantSize(context, 20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button + title
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(color: AppColors.greyWhite),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: AppColors.darkPurple),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Task Detail',
                              style: AppStyles.stylebold24(context)
                                  .copyWith(color: AppColors.darkPurple),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsiveComponantSize(context, 24)),

                    // ── Main card ───────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(
                          responsiveComponantSize(context, 20)),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.greyWhite),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name + done toggle
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => setState(() => _done = !_done),
                                child: Icon(
                                  _done
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: _done
                                      ? const Color(0xff388E3C)
                                      : AppColors.grey,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.task.name,
                                  style: AppStyles.stylebold24(context)
                                      .copyWith(
                                    fontSize:
                                        responsiveComponantSize(context, 18),
                                    color: AppColors.darkPurple,
                                    decoration: _done
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: responsiveComponantSize(context, 16)),

                          // Priority badge
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: _priorityColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: _priorityColor.withOpacity(0.4)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.flag,
                                        size: 14, color: _priorityColor),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.task.priority.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: _priorityColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Status badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: _statusColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _statusText,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: responsiveComponantSize(context, 20)),

                          const Divider(height: 1, color: AppColors.greyWhite),
                          SizedBox(height: responsiveComponantSize(context, 16)),
                          
                          // Completion Slider
                          Text('Task Progress: ${(_completionRate * 100).toInt()}%',
                              style: AppStyles.styleSemiBold14(context)),
                          Slider(
                            value: _completionRate,
                            min: 0.0,
                            max: 1.0,
                            divisions: 20,
                            activeColor: AppColors.deepPurple,
                            inactiveColor: AppColors.greyWhite,
                            onChanged: _onSliderChanged,
                          ),
                          SizedBox(height: responsiveComponantSize(context, 8)),

                          // Description
                          Text('Description',
                              style: AppStyles.styleSemiBold14(context)),
                          SizedBox(height: responsiveComponantSize(context, 6)),
                          Text(
                            widget.task.description,
                            style: AppStyles.styleRegular12(context)
                                .copyWith(color: AppColors.moreGrey, height: 1.5),
                          ),
                          SizedBox(height: responsiveComponantSize(context, 20)),

                          const Divider(height: 1, color: AppColors.greyWhite),
                          SizedBox(height: responsiveComponantSize(context, 16)),

                          // Info rows
                          _InfoRow(
                            icon: Icons.calendar_today_outlined,
                            label: 'Due Date',
                            value: _formatDate(widget.task.date),
                          ),
                          SizedBox(height: responsiveComponantSize(context, 10)),
                          _InfoRow(
                            icon: Icons.calendar_month_outlined,
                            label: 'Created',
                            value: _formatDate(widget.task.createdat),
                          ),
                          if (assignee != null) ...[
                            SizedBox(
                                height: responsiveComponantSize(context, 10)),
                            Row(
                              children: [
                                const Icon(Icons.person_outline,
                                    size: 18, color: AppColors.deepPurple),
                                const SizedBox(width: 8),
                                Text('Assigned to',
                                    style: AppStyles.styleRegular12(context)
                                        .copyWith(color: AppColors.grey)),
                                const Spacer(),
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Color(
                                      int.parse(assignee['color']!)),
                                  child: Text(
                                    assignee['initials']!,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(assignee['name']!,
                                    style:
                                        AppStyles.styleSemiBold12(context)),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small info row helper
// ─────────────────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.deepPurple),
        const SizedBox(width: 8),
        Text(label,
            style: AppStyles.styleRegular12(context)
                .copyWith(color: AppColors.grey)),
        const Spacer(),
        Text(value,
            style: AppStyles.styleSemiBold12(context)
                .copyWith(color: AppColors.darkPurple)),
      ],
    );
  }
}
