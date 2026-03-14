import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/features/home/presentation/view/wiget/card_project.dart';

class ProjectList extends StatelessWidget {
   ProjectList({super.key});
final List<String> titles=[
   'todo',
   'inprogress',
   'completed',
   'holding'
 ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight(context) / 5,
      child: ListView.builder(
        itemCount: titles.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (contx, index) {
          return  ProjectCard(title: titles[index],);
        },
      ),
    );
  }
}
