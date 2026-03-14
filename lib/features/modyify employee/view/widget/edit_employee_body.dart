import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/Speciality/speciality_model.dart';
import 'package:task_manager/core/models/employee/employee_data/employee_data.dart';
import 'package:task_manager/core/models/employee/employee_data/phone_number.dart';
import 'package:task_manager/core/services/remote_repo/admin/employees/employee.dart';
import 'package:task_manager/core/shared%20widget/custom_button.dart';
import 'package:task_manager/core/shared%20widget/custom_text_field.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_cubit.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_state.dart';
import 'package:task_manager/features/speciality/view_model/speciality_cubit.dart';
import 'package:task_manager/features/speciality/view_model/speciality_state.dart';

class EditEmployeeBody extends StatefulWidget {
  final String id;
  const EditEmployeeBody({super.key, required this.id});

  @override
  _EditEmployeeBodyState createState() => _EditEmployeeBodyState();
}

class _EditEmployeeBodyState extends State<EditEmployeeBody> {
  final _formKey = GlobalKey<FormState>();
  late EmployeeData originalEmployee;
  Speciality? selectedSpecialty;
  final EmployeeServices employeeServices = EmployeeServices();
  @override
  void initState() {
    super.initState();
    // Ensure the cubits are available in the context
    context.read<EmployeesCubit>().getEmployeeById(widget.id);
    context.read<SpecialtyCubit>().getAllSpecialtys();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<EmployeesCubit, EmployeesState>(
            builder: (context, state) {
              var cubit = EmployeesCubit.get(context);
              if (state is EmployeesLoadingState) {
                return const Center(child: Text('Loading...'));
              } else if (state is EmployeesLoadedState) {
                final employee = state.employee;
                originalEmployee = employee!;
                cubit.emailController.text = employee.email;
                cubit.firstNameController.text = employee.firstName;
                cubit.secondNameController.text = employee.secondName;
                cubit.phoneController.text = employee.phoneNumber.phoneNumber;
                cubit.addressController.text = employee.address;

                // Initialize selectedSpecialty based on employee's specialityId


                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                                  'Edit Employee',
                                  style: AppStyles.stylebold24(context).copyWith(color: AppColors.darkPurple),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Email',
                                    style: AppStyles.styleMedium14(context).copyWith(color: AppColors.darkPurple),
                                  ),
                                  const SizedBox(height: 12),
                                  customTextFormField(
                                    controller: cubit.emailController,
                                    hint: employee.email,
                                    keyboardType: TextInputType.emailAddress,
                                    validation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Email';
                                      } else if (!RegExp(
                                          r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('First Name',
                                    style: AppStyles.styleMedium14(context).copyWith(color: AppColors.darkPurple),
                                  ),
                                  const SizedBox(height: 12),
                                  customTextFormField(
                                    controller: cubit.firstNameController,
                                    hint: employee.firstName,
                                    keyboardType: TextInputType.text,
                                    validation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter first name';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Second Name',
                                    style: AppStyles.styleMedium14(context).copyWith(color: AppColors.darkPurple),
                                  ),
                                  const SizedBox(height: 12),
                                  customTextFormField(
                                    controller: cubit.secondNameController,
                                    hint: employee.secondName,
                                    keyboardType: TextInputType.text,
                                    validation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter second name';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              BlocBuilder<SpecialtyCubit, SpecialtysState>(
                                builder: (context, state) {
                                  if (state is SpecialtysLoadingState) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (state is SpecialtysLoadedState) {
                                    final specialties = state.specialtys ??[];
                                    return DropdownButtonFormField2<Speciality>(
                                      isExpanded: true,
                                      value: selectedSpecialty,
                                      onChanged: (Speciality? value) {
                                        setState(() {
                                          selectedSpecialty = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      items: specialties.map((specialty) {
                                        return DropdownMenuItem<Speciality>(
                                          value: specialty,
                                          child: Text(specialty.name),
                                        );
                                      }).toList(),
                                      hint: Text(
                                          selectedSpecialty?.name ??  employee.specialityId.name,
                                        style: AppStyles.styleRegular12(context)
                                            .copyWith(fontSize: 14, color: AppColors.deepPurple),
                                      ),
                                    );

                                  } else if (state is SpecialtysErrorState) {
                                    return Center(
                                        child: Text(ErrorHandling.handleError(state.error )));
                                  } else {
                                    return const Center(child: Text('No Specialties Found'));
                                  }
                                },
                              ),
                              const SizedBox(height: 24),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Phone Number',
                                    style: AppStyles.styleMedium14(context).copyWith(color: AppColors.darkPurple),
                                  ),
                                  const SizedBox(height: 12),
                                  customTextFormField(
                                    controller: cubit.phoneController,
                                    hint: employee.phoneNumber.phoneNumber,
                                    keyboardType: TextInputType.text,
                                    validation: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a phone number';
                                      } else if (!RegExp(r'^\+?[0-9]{10,15}$')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid phone number';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Address',
                                    style: AppStyles.styleMedium14(context).copyWith(color: AppColors.darkPurple),
                                  ),
                                  const SizedBox(height: 12),
                                  customTextFormField(
                                    controller: cubit.addressController,
                                    hint: employee.address,
                                    keyboardType: TextInputType.text,
                                    validation: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter address';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              customButton(
                                buttontext: 'Edit Employee',
                                onpressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    final updatedEmployee = EmployeeData(
                                      email: cubit.emailController.text.isNotEmpty
                                          ? cubit.emailController.text
                                          : originalEmployee.email,
                                      firstName:
                                      cubit.firstNameController.text.isNotEmpty
                                          ? cubit.firstNameController.text
                                          : originalEmployee.firstName,
                                      secondName:
                                      cubit.secondNameController.text.isNotEmpty
                                          ? cubit.secondNameController.text
                                          : originalEmployee.secondName,
                                      phoneNumber:
                                      cubit.phoneController.text.isNotEmpty
                                          ? PhoneNumber.fromMap({
                                        'phoneNumber':
                                        cubit.phoneController.text,
                                        'dialCode': '+20',
                                      })
                                          : originalEmployee.phoneNumber,
                                      address:
                                      cubit.addressController.text.isNotEmpty
                                          ? cubit.addressController.text
                                          : originalEmployee.address,
                                      img: originalEmployee.img,
                                      hidden: originalEmployee.hidden,
                                      id: originalEmployee.id,
                                      specialityId: selectedSpecialty ??
                                          originalEmployee
                                              .specialityId, // Ensure consistency
                                    );

                                    if (updatedEmployee != originalEmployee) {
                                      cubit.editEmployee(
                                          widget.id, updatedEmployee,context);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text('No changes made')),
                                      );
                                    }
                                  }

                                }, context: context,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Center(child: Text('Error loading data'));
            },
          ),
        ),

    );
  }
}
