import 'dart:math';

import 'package:flutter/material.dart';

double screenWidth(context) {
  return MediaQuery.of(context).size.width;
}

double screenHeight(context) {
  return MediaQuery.of(context).size.height;
}
String? token;
String? role;
String?id;
bool isView = true;
String selectedTaskPriority = 'low';
String selectedProjectPriority = 'low';
String authEmployeeId='';
 List<String> selectedEmployees = [];

double responsiveComponantSize(BuildContext context, double fontSize) {
  double baseWidth = 428; // base screen width
  double baseHeight = 926; // base screen height
  double baseDiagonal = sqrt(baseWidth * baseWidth + baseHeight * baseHeight);
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  double screenDiagonal = sqrt(screenWidth * screenWidth + screenHeight * screenHeight);

  // Scale the font size based on the ratio of the current diagonal to the base diagonal
  return (fontSize / baseDiagonal) * screenDiagonal;
}
