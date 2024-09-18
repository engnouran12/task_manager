import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/profileInfo/presentation/view_model/profile_info_cubit.dart';
import 'package:task_manager/features/profileInfo/presentation/views/widgets/profile_info_column.dart';

class ProfileDetailsInfoBody extends StatefulWidget {
  const ProfileDetailsInfoBody({super.key});

  @override
  State<ProfileDetailsInfoBody> createState() => _ProfileDetailsInfoBodyState();
}

class _ProfileDetailsInfoBodyState extends State<ProfileDetailsInfoBody> {

  Future<void> _refreshEmployeeSelection() async {
    context.read<ProfileInfoCubit>().getEmployeeById(id!);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshEmployeeSelection,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: responsiveComponantSize(context, 15),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsiveComponantSize(context, 24)),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.greyWhite),
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.darkPurple,
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Personal Info',
                          style: AppStyles.stylebold24(context)
                              .copyWith(color: AppColors.darkPurple),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: responsiveComponantSize(context, 28),
              ),
              const ProfileInfoColumn(),
            ],
          ),
        ),
      ),
    );
  }
}
