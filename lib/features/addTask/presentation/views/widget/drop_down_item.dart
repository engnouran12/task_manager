import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';

class DropDownButton<T> extends StatefulWidget {
  const DropDownButton({
    super.key,
    this.selectedValue,
    required this.items,
    required this.hinttext,
    required this.itemBuilder,
    required this.onChanged,
  });

  final T? selectedValue;
  final List<T> items;
  final String hinttext;
  final Widget Function(T item) itemBuilder;
  final void Function(T? value) onChanged;

  @override
  State<DropDownButton<T>> createState() => _DropDownButtonState<T>();
}

class _DropDownButtonState<T> extends State<DropDownButton<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      isExpanded: true,
      validator: (value) {
        if (value == null) {
          return 'Please select a value.';
        }
        return null;
      },
      value: selectedValue,
      onChanged: (T? value) {
        setState(() {
          selectedValue = value;
        });
        widget.onChanged(value);
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),

        ),
      ),
      items: widget.items
          .map((item) => DropdownMenuItem<T>(
        value: item,
        child: widget.itemBuilder(item),
      ))
          .toList(),
      hint: Text(
        widget.hinttext,
        style: AppStyles.styleRegular12(context)
            .copyWith(fontSize: responsiveComponantSize(context, 14), color: AppColors.deepPurple),
      ),
    );
  }
}
