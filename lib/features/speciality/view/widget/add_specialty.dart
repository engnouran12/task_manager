import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/models/Speciality/speciality_model.dart';
import 'package:task_manager/features/speciality/view_model/speciality_cubit.dart';

class AddSpecialtyDialog extends StatefulWidget {
  const AddSpecialtyDialog({super.key});

  @override
  _AddSpecialtyDialogState createState() => _AddSpecialtyDialogState();
}

class _AddSpecialtyDialogState extends State<AddSpecialtyDialog> {
  final TextEditingController _specialityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Speciality'),
      content: TextField(
        controller: _specialityController,
        decoration: const InputDecoration(
          hintText: 'Enter speciality name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                final specialityName = _specialityController.text.trim();
                if (specialityName.isNotEmpty) {
                  // Execute the addSpeciality method in the Cubit
                  context.read<SpecialtyCubit>().addSpeciality(specialityName as Speciality,context);
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                final specialityName = _specialityController.text.trim();
                if (specialityName.isNotEmpty) {
                  // Execute the addSpeciality method in the Cubit
                  context.read<SpecialtyCubit>().addSpeciality(specialityName as Speciality,context);
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ],
    );
  }
}
