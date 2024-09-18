import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_cubit.dart';
import 'package:task_manager/features/profile/presentation/view/widget/profile_data.dart';
import 'package:task_manager/features/profile/presentation/view/widget/row_profile_tittle.dart';
import 'package:task_manager/features/profile/presentation/view_model/profile_cubit.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  void initState() {
    super.initState();
    _refreshProfileData();
  }

  Future<void> _refreshProfileData() async {
    // Add your refresh logic here, such as re-fetching data
    context.read<ProfileCubit>().getEmployeeById(id!);
    context.read<EmployeesCubit>().getEmployeeById(id!);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _refreshProfileData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Ensures that the scroll view can always trigger the refresh
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: responsiveComponantSize(context, 55),
                      bottom: responsiveComponantSize(context, 24)),
                  child: Text(
                    'Profile',
                    style: AppStyles.stylebold24(context),
                  ),
                ),
              ),
              const Center(
                child: DataProfile(),
              ),
              SizedBox(
                height: responsiveComponantSize(context, 30),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsiveComponantSize(context, 24)),
                child: const ProfileRowsTittle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
