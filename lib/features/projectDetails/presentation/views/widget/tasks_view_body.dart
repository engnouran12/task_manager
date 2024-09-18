import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/shared%20widget/build_taps.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/projectDetails/presentation/views/widget/filter_project_task_list.dart';

class TasksViewBody extends StatefulWidget {
  final String projectid;
  final bool? status;

  const TasksViewBody({super.key, required this.projectid, this.status});

  @override
  _TasksViewBodyState createState() => _TasksViewBodyState();
}

class _TasksViewBodyState extends State<TasksViewBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _getInitialTabIndex(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _getInitialTabIndex() {
    return widget.status == true ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.only(
              left: responsiveComponantSize(context, 24),
              right: responsiveComponantSize(context, 24),
              top: responsiveComponantSize(context, 10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Tasks',
                        style: AppStyles.stylebold24(context)
                            .copyWith(color: AppColors.darkPurple),
                      ),
                    ),
                  ),
                ],
              ),
               SizedBox(height: responsiveComponantSize(context, 25)),
              TabBar(
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
                  TabWidget(label: 'In Progress'),
                  TabWidget(label: 'Completed'),
                ],
              ),
               SizedBox(height: responsiveComponantSize(context, 25)),
              Text(
                "Tasks",
                style: AppStyles.styleSemiBold14(context)
                    .copyWith(color: AppColors.darkPurple),
              ),
               SizedBox(height: responsiveComponantSize(context, 16)),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    FilterProjectTaskList(
                      projectid: widget.projectid,
                      status: false
                      //widget.status!,
                    ),
                    FilterProjectTaskList(
                      projectid: 
                      widget.projectid,
                      status: true
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
