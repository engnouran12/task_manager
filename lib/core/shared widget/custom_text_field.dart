
import 'package:flutter/material.dart';
import 'package:task_manager/core/themes/colors.dart';

Widget customTextFormField({
  required TextEditingController controller,
  String? name,
  String? hint,
  required TextInputType keyboardType,
  final bool isDescription = false,
  final bool isThierLabel = false,
  String? Function(String?)? validation,
  Function? Function()? tapfunction,
  bool obscure = false,
  Widget? suffixIcon,
}) {
  return TextFormField(
    onTap:tapfunction ,
    obscureText: obscure,
    controller: controller,
    validator: validation,
    maxLines: obscure ? 1 : (isDescription ? 6 : 1),
    maxLength: isDescription ? 100 : null,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      suffixIcon: suffixIcon,
      hintText: hint,
      labelText: isThierLabel ? name : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      hintStyle: const TextStyle(color: AppColors.grey),
    ),
  );
}
