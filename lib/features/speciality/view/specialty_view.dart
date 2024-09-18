import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/helper/error_handling.dart';

import 'package:task_manager/core/models/Speciality/speciality_model.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/features/speciality/view/widget/speciality_body.dart';
import 'package:task_manager/features/speciality/view_model/speciality_cubit.dart';

class SpecialtyView extends StatelessWidget {
  SpecialtyView({super.key});
  final TextEditingController _specialityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:role!='employee'? FloatingActionButton(
        onPressed: () {
          _specialityController.clear(); // Clear the text field before showing dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add Speciality'),
                content: TextField(
                  controller: _specialityController,
                  decoration: const InputDecoration(
                    hintText: 'Enter speciality name',
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          final String specialityName = _specialityController.text.trim();
                          if (specialityName.isNotEmpty) {
                            final speciality = Speciality(name: specialityName);
                            context.read<SpecialtyCubit>().addSpeciality(speciality, context).then((_) {
                              Navigator.of(context).pop(); // Close the dialog after success
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Speciality added successfully')),
                              );
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(ErrorHandling.handleError(error! as String))),
                              );
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Speciality name cannot be empty')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: AppColors.deepPurple,
        child: const Icon(
          Icons.add,
          color: AppColors.white,
        ),
      )
      : null,
      body: const SpecialityBody(),
    );
  }
}
