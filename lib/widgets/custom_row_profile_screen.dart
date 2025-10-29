import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/widgets/custom_icon_container.dart';
import 'package:flutter/material.dart';

class CustomRowProfileScreen extends StatelessWidget {
  const CustomRowProfileScreen({
    super.key,
    required this.iconData,
    required this.title,
    this.onTap,
    this.backgroundColor = AppColor.lightGreenColor,
    this.iconColor = AppColor.greenColor,
  });
  final IconData iconData;
  final String title;
  final void Function()? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          CustomIconContainer(
            iconData: iconData,
            borderRadius: 50,
            padding: 9,
            backgroundColor: backgroundColor,
            iconColor: iconColor,
          ),
          SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }
}
