import 'package:cure_link/utils/app_color.dart';
import 'package:flutter/material.dart';

class CustomRowSeeAllHomeScreen extends StatelessWidget {
  const CustomRowSeeAllHomeScreen({
    super.key,
    required this.title,

    this.onSeeAllTap,
  });
  final String title;

  final void Function()? onSeeAllTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onSeeAllTap,
          child: Text(
            'See All',
            style: TextStyle(fontSize: 14, color: AppColor.greenColor),
          ),
        ),
      ],
    );
  }
}
