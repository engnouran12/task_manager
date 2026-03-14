import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/shared%20widget/custom_search_bar.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/speciality/view/widget/speciality_list.dart';
import 'package:task_manager/features/speciality/view_model/speciality_cubit.dart';


class SpecialityBody extends StatefulWidget {
  const SpecialityBody({super.key,});

  @override
  State<SpecialityBody> createState() => _SpecialityBodyState();
}

class _SpecialityBodyState extends State<SpecialityBody> {
  @override
  void initState() {
    super.initState();
    // Initialize any state here if needed
    context.read<SpecialtyCubit>().getAllSpecialtys();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Padding(
            padding:  EdgeInsets.symmetric(
                horizontal: responsiveComponantSize(context, 24),
                vertical: responsiveComponantSize(context, 22) ),
            child: Column(
              children: [
                Column(
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
                              'Specialty',
                              style: AppStyles.stylebold24(context).copyWith(color: AppColors.darkPurple),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: responsiveComponantSize(context, 16),
                    ),
                    const CustomSearchBar(hinttext: 'Search Specialty.... '),
                    SizedBox(
                      height: responsiveComponantSize(context, 14),
                    ),
                  ],
                ),
                const Expanded(child: SpecialityList()),
              ],
            )
        ),
      ),

    );
  }
}
