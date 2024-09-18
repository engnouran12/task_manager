
import 'package:flutter/material.dart';
import 'wiget/home_body.dart';

class Homeview extends StatelessWidget {
  const Homeview({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: HomeBody(),
      ),
    );
  }
}
