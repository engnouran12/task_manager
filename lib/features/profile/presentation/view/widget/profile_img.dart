import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_cubit.dart';
import 'package:task_manager/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:task_manager/features/profile/presentation/view_model/profile_state.dart';

class ProfileImg extends StatefulWidget {
  final String? img;
  const ProfileImg({super.key, this.img});

  @override
  State<ProfileImg> createState() => _ProfileImgState();
}

class _ProfileImgState extends State<ProfileImg> {
  late EmployeeData originalEmployee;

  @override
  void initState() {
    super.initState();
      final cubit = context.read<ProfileCubit>();
      cubit.getEmployeeById(id!);

  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadingState) {
          return const Center(child: Text('Loading...'));
        } else if (state is ProfileLoadedState) {
          final employee = state.employee;
          originalEmployee = employee!;
          return Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.img!),
                radius: screenWidth(context) / 5,
              ),
              IconButton(
                onPressed: () async {
                  final cubit = context.read<ProfileCubit>();
                  await cubit.uploadImage(context);


                  if (cubit.imagePath.isNotEmpty && cubit.imagePath != originalEmployee.img) {
                    final updatedEmployee = originalEmployee.copyWith(img: cubit.imagePath);
                    await cubit.editEmployee(id!, updatedEmployee, context);
                    context.read<EmployeesCubit>().getEmployeeById(id!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No image changed')),
                    );
                  }
                },
                icon: CircleAvatar(
                  backgroundColor: AppColors.deepPurple,
                  radius: screenWidth(context) / 19,
                  child: const Icon(
                    Icons.mode_edit_rounded,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          );
        }
        return const Center(child: Text('Error loading image'));
      },
    );
  }
}
