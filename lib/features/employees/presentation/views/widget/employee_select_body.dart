import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/shared%20widget/custom_button.dart';
import 'package:task_manager/core/shared%20widget/custom_search_bar.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';
import 'package:task_manager/features/employees/presentation/views/widget/employee_selecttion_list.dart';

class AddEmployeeToProject extends StatelessWidget {
  const AddEmployeeToProject({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: CustomScrollView(
            slivers: [
               SliverToBoxAdapter(
                child: Padding(
                  padding:  EdgeInsets.only(
                      left: responsiveComponantSize(context, 24),
                      right: responsiveComponantSize(context, 24)),
                  child: Column(
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
                                Navigator.pop(context,true);
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
      
                      const CustomSearchBar(hinttext: 'Search Employee.... '),
                      SizedBox(height: responsiveComponantSize(context, 12)),

                    ],
                  ),
                ),
              ),
               SliverToBoxAdapter(child: Padding(
                padding:  EdgeInsets.only(
                    left: responsiveComponantSize(context, 24),
                    right: responsiveComponantSize(context, 24)),
                child: const EmployeeSelectionList(),
              )),
              // const AddEmployeeList(),
               SliverToBoxAdapter(
                child: SizedBox(
                  height: responsiveComponantSize(context, 16),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:  EdgeInsets.only(
                      left: responsiveComponantSize(context, 24),
                      right: responsiveComponantSize(context, 24)),
                  child: customButton(
                    buttontext: 'Add Employee',
                    onpressed: () {
                      Navigator.pop(context);
                    }, context: context,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: responsiveComponantSize(context, 45),
                ),
              ),
            ],
          )),
    );
  }
}
