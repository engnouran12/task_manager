import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/services/local/shared_data.dart';
import 'package:task_manager/core/shared%20widget/custom_profile_row.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/auth/presentation/view/sign_up_view.dart';
import 'package:task_manager/features/home/presentation/view_model/bottom_nav_bar_cubit.dart';
import 'package:task_manager/features/home/presentation/view_model/bottom_nav_employee_cubit.dart';
import 'package:task_manager/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:task_manager/features/profile/presentation/view_model/profile_state.dart';
import 'package:task_manager/features/profileInfo/presentation/views/profile_info_view.dart';

class ProfileRowsTittle extends StatelessWidget {
   const ProfileRowsTittle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          var cubit = ProfileCubit.get(context);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customProfilRow(
                context: context,
                onPressed: ()async {
                  cubit.result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileInfoView(),
                    ),
                  );
                },
                name: 'Personal Info',
              ),
              const Divider(
                thickness: 0.9,
              ),
              customProfilRow(
                context: context,
                onPressed: () {},
                name: 'Language',
              ),
              const Divider(
                thickness: 0.9,
              ),
              customProfilRow(
                context: context,
                onPressed: () {},
                name: 'Privacy & Security',
              ),
              const Divider(
                thickness: 0.5,
              ),
              customProfilRow(
                context: context,
                onPressed: () {},
                name: 'Help Center',
              ),
              const Divider(
                thickness: 0.4,
              ),
              SizedBox(
                height: responsiveComponantSize(context, 10),
              ),
              InkWell(
                onTap: () async {
                  // Add your logout function here
                  await cubit.logout(context);
                 
                  final LocalRepo localRepo = GetIt.instance<LocalRepo>();
                  await localRepo.deleteToken();
                  role=='employee'?BottomNavEmployeeCubit.get(context).onItemTapped(0)
                  :BottomNavBarCubit.get(context).onItemTapped(0);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpView()),
                  );

                },
                child: Text(
                  'Log Out',
                  style: AppStyles.styleSemiBold14(context)
                      .copyWith(fontSize: responsiveComponantSize(context, 16), color: AppColors.red),
                ),
              ),
            ],
          );
        },

    );
  }
}
