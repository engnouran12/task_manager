import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/features/speciality/view/widget/speciality_card.dart';
import 'package:task_manager/features/speciality/view_model/speciality_cubit.dart';
import 'package:task_manager/features/speciality/view_model/speciality_state.dart';
class SpecialityList extends StatelessWidget {
  const SpecialityList({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpecialtyCubit,SpecialtysState>(
        builder: (context,state){
      if (state is SpecialtysLoadingState) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is SpecialtysLoadedState) {
        final specialtys = state.specialtys;
        return ListView.builder(

          itemCount: specialtys!.length,
          itemBuilder: (context, index) {
            final speciality=specialtys[index];
            return Padding(
              padding:  EdgeInsets.only(top: responsiveComponantSize(context, 8)),
              child:SpecialityCard(specialty: speciality,),
            );
          },
        );
      } else if (state is SpecialtysErrorState) {
        return Center(child: Text('Error: ${state.error.toString()}'));
      } else {
        return const Center(child: Text('No Specialtys Found'));
      }
        },

    );
  }
}
