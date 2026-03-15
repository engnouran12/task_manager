import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/mock/mock_data.dart';
import 'package:task_manager/core/models/Speciality/speciality_model.dart';
import 'package:task_manager/core/shared%20widget/custom_button.dart';
import 'package:task_manager/core/shared%20widget/custom_text_field.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';

/// Fully static Add-Employee form — no API / Bloc needed.
class AddEmployeeBody extends StatefulWidget {
  const AddEmployeeBody({super.key});

  @override
  State<AddEmployeeBody> createState() => _AddEmployeeBodyState();
}

class _AddEmployeeBodyState extends State<AddEmployeeBody> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _secondNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  Speciality? _selectedSpecialty;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _firstNameCtrl.dispose();
    _secondNameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSpecialty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a specialty')),
      );
      return;
    }

    setState(() => _isLoading = true);
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // In mock mode we just add inline to the list so the list screen reflects it
    MockData.employeeDataList.add(
      MockData.employeeDataList.first.copyWith(
        firstName: _firstNameCtrl.text.trim(),
        secondName: _secondNameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        specialityId: _selectedSpecialty,
      ),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.deepPurple,
        content: Text(
          'Employee "${_firstNameCtrl.text.trim()} ${_secondNameCtrl.text.trim()}" added successfully!',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

    Navigator.pop(context, true); // signal refresh to caller
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsiveComponantSize(context, 24),
              vertical: responsiveComponantSize(context, 22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ─────────────────────────────────────────────
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.greyWhite),
                        color: AppColors.white,
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
                          'Add Employee',
                          style: AppStyles.stylebold24(context)
                              .copyWith(color: AppColors.darkPurple),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsiveComponantSize(context, 30)),

                // ── Form ───────────────────────────────────────────────
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email
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
                        controller: _emailCtrl,
                        name: 'email',
                        keyboardType: TextInputType.emailAddress,
                        isThierLabel: true,
                      ),
                      SizedBox(height: responsiveComponantSize(context, 24)),

                      // Password
                      customTextFormField(
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          } else if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                        controller: _passwordCtrl,
                        name: 'password',
                        keyboardType: TextInputType.text,
                        isThierLabel: true,
                      ),
                      SizedBox(height: responsiveComponantSize(context, 24)),

                      // First Name
                      customTextFormField(
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter first name';
                          }
                          return null;
                        },
                        controller: _firstNameCtrl,
                        hint: 'First Name',
                        name: 'First Name',
                        keyboardType: TextInputType.text,
                        isThierLabel: true,
                      ),
                      SizedBox(height: responsiveComponantSize(context, 24)),

                      // Second Name
                      customTextFormField(
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter second name';
                          }
                          return null;
                        },
                        controller: _secondNameCtrl,
                        hint: 'Second Name',
                        name: 'Second Name',
                        keyboardType: TextInputType.text,
                        isThierLabel: true,
                      ),
                      SizedBox(height: responsiveComponantSize(context, 24)),

                      // Specialty Dropdown — from mock data
                      DropdownButtonFormField2<Speciality>(
                        isExpanded: true,
                        validator: (value) {
                          if (value == null) return 'Please select a specialty.';
                          return null;
                        },
                        value: _selectedSpecialty,
                        onChanged: (Speciality? value) {
                          setState(() => _selectedSpecialty = value);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: MockData.specialties.map((specialty) {
                          return DropdownMenuItem<Speciality>(
                            value: specialty,
                            child: Text(specialty.name),
                          );
                        }).toList(),
                        hint: Text(
                          _selectedSpecialty?.name ?? 'Choose Specialty',
                          style: AppStyles.styleRegular12(context).copyWith(
                            fontSize: responsiveComponantSize(context, 14),
                            color: AppColors.deepPurple,
                          ),
                        ),
                      ),
                      SizedBox(height: responsiveComponantSize(context, 24)),

                      // Phone Number
                      customTextFormField(
                        validation: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          } else if (!RegExp(r'^\+?[0-9]{10,15}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        controller: _phoneCtrl,
                        hint: 'Phone Number',
                        name: 'Phone Number',
                        keyboardType: TextInputType.text,
                        isThierLabel: true,
                      ),
                      SizedBox(height: responsiveComponantSize(context, 24)),

                      // Address
                      customTextFormField(
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Address';
                          }
                          return null;
                        },
                        controller: _addressCtrl,
                        hint: 'Address',
                        name: 'Address',
                        keyboardType: TextInputType.text,
                        isThierLabel: true,
                      ),
                      SizedBox(height: screenHeight(context) / 10),

                      // Submit button
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : customButton(
                              buttontext: 'Add Employee',
                              onpressed: _submit,
                              context: context,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
