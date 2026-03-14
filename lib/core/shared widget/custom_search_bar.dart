import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key, required this.hinttext});
  final String  hinttext;

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Container(
      height: screenHeight(context) / 17,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin:  EdgeInsets.only(top: responsiveComponantSize(context, 5)),
      // padding: EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: GlobalKey<FormState>(), // Add this line to provide a key
        child: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            prefixIcon: IconButton(
                icon: Icon(
                  Icons.search,
                  size: screenWidth(context) / 12,
                  color: AppColors.deepPurple,
                ),
                onPressed: () {

                }),
            hintText: hinttext,
            hintStyle:AppStyles.styleRegular12(context),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
          onFieldSubmitted: (String? value) {
            searchController.text = value!;
          },
        ),
      ),
    );
  }
}
