import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/shared%20widget/build_taps.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/projectTask/presentation/view/widget/filter_projects_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/projectTask/presentation/view_model/tap_cubit.dart';

class ProjectState extends StatefulWidget {
  final String? status;

  const ProjectState({super.key, this.status});

  @override
  _ProjectStateState createState() => _ProjectStateState();
}

class _ProjectStateState extends State<ProjectState> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: _getInitialTabIndex(),
    );
    _tabController.addListener(_onTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChange() {
    if (_tabController.indexIsChanging) {
      context.read<TabCubit>().changeTab(_tabController.index);
    }
  }

  int _getInitialTabIndex() {
    switch (widget.status) {
      case 'todo':
        return 0;
      case 'inprogress':
        return 1;
      case 'completed':
        return 2;
      case 'holding':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: screenHeight(context) / 15,
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.zero,
            labelPadding:  EdgeInsets.only(right: responsiveComponantSize(context, 5)),
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.deepPurple.withOpacity(0.3),
            ),
            labelStyle: AppStyles.styleMedium14(context).copyWith(fontSize: responsiveComponantSize(context, 10)),
            tabs: const [
              TabWidget(label: 'To do'),
              TabWidget(label: 'In Progress'),
              TabWidget(label: 'Completed'),
              TabWidget(label: 'Holding'),
            ],
          ),
        ),
         SizedBox(height: responsiveComponantSize(context, 16)),
        Text(
          'Projects',
          style:
              AppStyles.styleSemiBold20(context).copyWith(color: AppColors.darkPurple),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics:
                const NeverScrollableScrollPhysics(),
                 // Disable swipe gestures
            children: const [
              FilterProjectsList(status: 'todo'),
              FilterProjectsList(status: 'inprogress'),
              FilterProjectsList(status: 'completed'),
              FilterProjectsList(status: 'holding'),
            ],
          ),
        ),
      ],
    );
  }
}
