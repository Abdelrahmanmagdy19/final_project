import 'package:cure_link/utils/app_color.dart';
import 'package:flutter/material.dart';

class CustomIconContainer extends StatelessWidget {
  const CustomIconContainer({
    super.key,
    required this.iconData,
    required this.borderRadius,
    required this.padding,
    this.onTap,
  });
  final IconData iconData;
  final double borderRadius;
  final double padding;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: AppColor.lightGreenColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppColor.greenColor, width: 0.5),
        ),
        child: Icon(iconData, color: AppColor.greenColor, size: 24),
      ),
    );
  }
}
