import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/themes/colors.dart';
import 'package:task_manager/core/themes/style.dart';

class OverViewCard extends StatefulWidget {
  final String description;
  const OverViewCard({super.key, required this.description});

  @override
  State<OverViewCard> createState() => _OverViewCardState();
}

class _OverViewCardState extends State<OverViewCard>
    with SingleTickerProviderStateMixin {
  bool ismore = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyWhite),
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding:  EdgeInsets.all(responsiveComponantSize(context, 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Overview',
              style: AppStyles.styleSemiBold14(context),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: Text(
                widget.description,
                maxLines: ismore ? null : 3,
                overflow: TextOverflow.fade,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  ismore = !ismore;
                });
              },
              child: Text(
                ismore ? 'See less' : 'See more',
                style: const TextStyle(color: AppColors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
