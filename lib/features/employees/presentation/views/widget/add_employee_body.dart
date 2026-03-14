import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';
import 'package:task_manager/core/models/Speciality/speciality_model.dart';
import 'package:task_manager/core/models/employee/employee.dart';
import 'package:task_manager/core/models/employee/employee_data/phone_number.dart';
import 'package:task_manager/core/services/remote_repo/admin/employees/employee.dart';
import 'package:task_manager/core/services/remote_repo/admin/spacilitys/spacility.dart';
import 'package:task_manager/core/shared%20widget/custom_button.dart';
import 'package:task_manager/core/shared%20widget/custom_text_field.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/employees/presentation/view_model/employees_cubit.dart';
import 'package:task_manager/features/speciality/view_model/speciality_cubit.dart';
import 'package:task_manager/features/speciality/view_model/speciality_state.dart';

class AddEmployeeBody extends StatefulWidget {
  const AddEmployeeBody({super.key});

  @override
  State<AddEmployeeBody> createState() => _AddEmployeeBodyState();
}

class _AddEmployeeBodyState extends State<AddEmployeeBody> {
  final _formKey = GlobalKey<FormState>();
  final EmployeeServices employeeServices = EmployeeServices();
  final SpecialityServices specialityServices = SpecialityServices();

  Speciality? selectedSpecialty;
  @override
  void initState() {
    super.initState();
    // Initialize the EmployeesCubit and SpecialtyCubit
     context.read<SpecialtyCubit>().getAllSpecialtys();
    _refreshEmployeeSelection();
  }
  Future<void> _refreshEmployeeSelection()async {
    await context.read<EmployeesCubit>().getAllEmployees();
  }

  @override
  Widget build(BuildContext context) {
    var employeesCubit = context.read<EmployeesCubit>();

    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: ()async{
            await _refreshEmployeeSelection();// Initialize the Cubit here
            return true;
          },
          child: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.symmetric(
                  horizontal: responsiveComponantSize(context, 24),
                  vertical: responsiveComponantSize(context, 22)),
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
                          icon: const Icon(Icons.arrow_back, color: AppColors.darkPurple),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Add Employee',
                            style: AppStyles.stylebold24(context).copyWith(color: AppColors.darkPurple),
                          ),
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: responsiveComponantSize(context, 30)),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        customTextFormField(
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
                          controller: employeesCubit.emailController,
                          name: 'email',
                          keyboardType: TextInputType.emailAddress,
                          isThierLabel: true,
                        ),
                        SizedBox(height: responsiveComponantSize(context, 24)),
                        customTextFormField(
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }else if (value.length<8) {
                              return 'you enter a password less than 8 ';
                            }
                            return null;
                          },
                          controller: employeesCubit.passwordController,
                          name: 'password',
                          keyboardType: TextInputType.text,
                          isThierLabel: true,
                        ),
                        SizedBox(height: responsiveComponantSize(context, 24)),
                        customTextFormField(
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter first name';
                            }
                            return null;
                          },
                          controller: employeesCubit.firstNameController,
                          hint: 'First Name',
                          name: 'First Name',
                          keyboardType: TextInputType.text,
                          isThierLabel: true,
                        ),
                        SizedBox(height: responsiveComponantSize(context, 24)),
                        customTextFormField(
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter second name';
                            }
                            return null;
                          },
                          controller: employeesCubit.secondNameController,
                          hint: 'Second Name',
                          name: 'Second Name',
                          keyboardType: TextInputType.text,
                          isThierLabel: true,
                        ),
                        SizedBox(height: responsiveComponantSize(context, 24)),
                        BlocBuilder<SpecialtyCubit, SpecialtysState>(
                          builder: (context, state) {
                            if (state is SpecialtysLoadingState) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (state is SpecialtysLoadedState) {
                              final specialties = state.specialtys ?? [];
                              return DropdownButtonFormField2<Speciality>(
                                isExpanded: true,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a value.';
                                  }
                                  return null;
                                },
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
                                  selectedSpecialty?.name ?? 'Choose Specialty',
                                  style: AppStyles.styleRegular12(context)
                                      .copyWith(fontSize: responsiveComponantSize(context, 14), color: AppColors.deepPurple),
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
                        SizedBox(height: responsiveComponantSize(context, 24)),
                        customTextFormField(
                          validation: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a phone number';
                            } else if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                          controller: employeesCubit.phoneController,
                          hint: 'Phone Number',
                          name: 'Phone Number',
                          keyboardType: TextInputType.text,
                          isThierLabel: true,
                        ),
                        SizedBox(height: responsiveComponantSize(context, 24)),
                        customTextFormField(
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Address';
                            }
                            return null;
                          },
                          controller: employeesCubit.addressController,
                          hint: 'Address',
                          name: 'Address',
                          keyboardType: TextInputType.text,
                          isThierLabel: true,
                        ),
                        SizedBox(height: screenHeight(context) / 10),
                        customButton(
                          buttontext: 'Add Employee',
                          onpressed: () {
                            if (_formKey.currentState!.validate()) {
                              final employeeData = Employee(
                                id: '',
                                firstName: employeesCubit.firstNameController.text,
                                secondName: employeesCubit.secondNameController.text,
                                email: employeesCubit.emailController.text,
                                password: employeesCubit.passwordController.text,
                                phoneNumber: PhoneNumber(
                                  dialCode: '+20',
                                  phoneNumber: employeesCubit.phoneController.text,
                                ),
                                role: 'employee',
                                address: employeesCubit.addressController.text,
                                specialityId: selectedSpecialty!.id!,
                              );
                              employeesCubit.addEmployee(employeeData,context);


                            }
                          }, context: context,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
