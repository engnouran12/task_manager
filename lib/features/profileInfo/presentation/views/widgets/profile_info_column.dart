import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/models/employee/employee_data/phone_number.dart';
import 'package:task_manager/core/shared%20widget/custom_profile_info_row.dart';
import 'package:task_manager/core/shared%20widget/custom_text_field.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/profile/presentation/view/widget/profile_img.dart';
import 'package:task_manager/features/profileInfo/presentation/view_model/profile_info_cubit.dart';
import 'package:task_manager/features/profileInfo/presentation/view_model/profile_info_state.dart';

class ProfileInfoColumn extends StatefulWidget {
  const ProfileInfoColumn({super.key});

  @override
  _ProfileInfoColumnState createState() => _ProfileInfoColumnState();
}

class _ProfileInfoColumnState extends State<ProfileInfoColumn> {
  late EmployeeData originalEmployee;

  @override
  void initState() {
    super.initState();
    context.read<ProfileInfoCubit>().getEmployeeById(id!);
  }
  @override
  Widget build(BuildContext context) {
    if (id == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return  BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
        builder: (context, state) {
          var cubit = ProfileInfoCubit.get(context);
          if (state is ProfileInfoLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileInfoLoadedState) {
            final employee = state.employee;
            if (employee == null) {
              return const Center(child: Text('No Employee Data Found'));
            }
            originalEmployee = employee;
            // Update controllers with employee data if not already done
            if (!cubit.isFristNameEdit && cubit.fristnameController.text.isEmpty) {
              cubit.fristnameController.text = employee.firstName ;
            }
            if (!cubit.isSecondNameEdit && cubit.secondnameController.text.isEmpty) {
              cubit.secondnameController.text = employee.secondName;
            }
            if (!cubit.isPhoneEdit && cubit.phoneNumberController.text.isEmpty) {
              cubit.phoneNumberController.text = employee.phoneNumber.phoneNumber;
            }

            const String baseUrl = 'http://66.29.130.92:5070/';
            return Padding(
              padding:  EdgeInsets.symmetric(horizontal: responsiveComponantSize(context, 24)),
              child: Column(
                children: [
                  Center(child: ProfileImg(img: '$baseUrl${employee.img}')),
                  SizedBox(
                    height: responsiveComponantSize(context, 20),
                  ),
                  cubit.isFristNameEdit == false
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customProfileInfoRow(
                        context: context,
                        title: 'Frist Name',
                        text: employee.firstName ,
                      ),
                      InkWell(
                        onTap: () {
                          cubit.toggleEditMode('firstName',originalEmployee);
                        },
                        child: Text(
                          'Edit',
                          style: AppStyles.styleRegular12(context).copyWith(
                            fontSize: responsiveComponantSize(context, 16),
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    ],
                  )
                      : Column(
                    children: [
                      customTextFormField(
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter frist name';
                          }
                          return null;
                        },
                        controller: cubit.fristnameController,
                        name: 'Frist Name',
                        keyboardType: TextInputType.text,
                        isThierLabel: true,
                        suffixIcon: IconButton(
                          onPressed: () {
                            final updatedEmployee = EmployeeData(
                              email: originalEmployee.email,
                              firstName: cubit.fristnameController.text.isNotEmpty
                                  ? cubit.fristnameController.text
                                  : originalEmployee.firstName,
                              secondName: originalEmployee.secondName,
                              phoneNumber: originalEmployee.phoneNumber,
                              address:  originalEmployee.address,
                              img: originalEmployee.img,
                              hidden: originalEmployee.hidden,
                              id: originalEmployee.id,
                              specialityId: originalEmployee.specialityId,
                            );

                            // Check if there are any changes to update
                            if (updatedEmployee != originalEmployee) {
                              cubit.editEmployee(id!, updatedEmployee, context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No changes made')),
                              );
                            }
                            cubit.toggleEditMode('firstName',originalEmployee);
                          },
                          icon: const Icon(Icons.done),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight(context) / 38),
                  cubit.isSecondNameEdit == false
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customProfileInfoRow(
                        context: context,
                        title: 'Second Name',
                        text: employee.secondName ,
                      ),
                      InkWell(
                        onTap: () {
                          cubit.toggleEditMode('secondName',originalEmployee);
                        },
                        child: Text(
                          'Edit',
                          style: AppStyles.styleRegular12(context).copyWith(
                            fontSize: responsiveComponantSize(context, 16),
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    ],
                  )
                      : Column(
                    children: [
                      customTextFormField(
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter second name';
                          }
                          return null;
                        },
                        controller: cubit.secondnameController,
                        name: 'Second Name',
                        keyboardType: TextInputType.text,
                        isThierLabel: true,
                        suffixIcon: IconButton(
                          onPressed: () {
                            final updatedEmployee = EmployeeData(
                              email:  originalEmployee.email,
                              firstName: originalEmployee.firstName,
                              secondName: cubit.secondnameController.text.isNotEmpty
                                  ? cubit.secondnameController.text
                                  : originalEmployee.secondName,
                              phoneNumber:  originalEmployee.phoneNumber,
                              address: originalEmployee.address,
                              img: originalEmployee.img,
                              hidden: originalEmployee.hidden,
                              id: originalEmployee.id,
                              specialityId: originalEmployee.specialityId,
                            );

                            // Check if there are any changes to update
                            if (updatedEmployee != originalEmployee) {
                              cubit.editEmployee(id!, updatedEmployee, context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No changes made')),
                              );
                            }
                            cubit.toggleEditMode('secondName',originalEmployee);                          },
                          icon: const Icon(Icons.done),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight(context) / 38),
                  cubit.isPhoneEdit == false
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customProfileInfoRow(
                        context: context,
                        title: 'Phone Number',
                        text: employee.phoneNumber.phoneNumber,
                      ),
                      InkWell(
                        onTap: () {
                          cubit.toggleEditMode('phoneNumber',originalEmployee);                        },
                        child: Text(
                          'Edit',
                          style: AppStyles.styleRegular12(context).copyWith(
                            fontSize: responsiveComponantSize(context, 16),
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    ],
                  )
                      : Column(
                    children: [
                      customTextFormField(
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                        controller: cubit.phoneNumberController,
                        name: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        isThierLabel: true,
                        suffixIcon: IconButton(
                          onPressed: () {
                            final updatedEmployee = EmployeeData(
                              email: originalEmployee.email,
                              firstName:originalEmployee.firstName,
                              secondName:originalEmployee.secondName,
                              phoneNumber: cubit.phoneNumberController.text.isNotEmpty
                                  ? PhoneNumber.fromMap({
                                'phoneNumber': cubit.phoneNumberController.text,
                                'dialCode': '+20', // Use the appropriate dial code
                              })
                                  : originalEmployee.phoneNumber,
                              address: originalEmployee.address,
                              img: originalEmployee.img,
                              hidden: originalEmployee.hidden,
                              id: originalEmployee.id,
                              specialityId: originalEmployee.specialityId,
                            );

                            // Check if there are any changes to update
                            if (updatedEmployee != originalEmployee) {
                              cubit.editEmployee(id!, updatedEmployee, context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No changes made')),
                              );
                            }
                            cubit.toggleEditMode('phoneNumber',originalEmployee);                          },
                          icon: const Icon(Icons.done),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight(context) / 38),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customProfileInfoRow(
                        context: context,
                        title: 'Password',
                        text: '*********',
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (state is ProfileInfoErrorState) {
            return Center(
                child: Text(ErrorHandling.handleError(state.error)));
          } else {
            return const Center(child: Text('No Employees Found'));
          }
        },

    );
  }
}

