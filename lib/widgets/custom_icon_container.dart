import 'package:cure_link/utils/app_color.dart';
import 'package:flutter/material.dart';

class CustomIconContainer extends StatelessWidget {
  const CustomIconContainer({
    super.key,
    required this.iconData,
    required this.borderRadius,
    required this.padding,
    this.iconColor = AppColor.greenColor,
    this.onTap,
    this.backgroundColor = AppColor.lightGreenColor,
  });
  final IconData iconData;
  final double borderRadius;
  final double padding;
  final void Function()? onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Icon(iconData, color: iconColor, size: 24),
      ),
    );
  }
}
