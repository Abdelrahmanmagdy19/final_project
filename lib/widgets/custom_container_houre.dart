import 'package:cure_link/utils/app_color.dart';
import 'package:flutter/material.dart';

class CustomContainerHoure extends StatelessWidget {
  const CustomContainerHoure({
    super.key,
    required this.time,
    required this.isAvailable,
    required this.isSelected,
    required this.onTap,
  });

  final String time;
  final bool isAvailable;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // تم إصلاح استخدام withValues الخاطئ
    Color fadeColor = AppColor.greyColor.withValues(alpha: 0.3);

    Color borderColor = isAvailable
        ? (isSelected ? AppColor.greenColor : AppColor.greyColor)
        : fadeColor;

    Color backgroundColor = isSelected
        ? AppColor.greenColor
        : Colors.transparent;

    Color textColor = isAvailable
        ? (isSelected ? Colors.white : Colors.black)
        : AppColor.greyColor.withValues(alpha: 0.5);

    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Container(
        alignment: Alignment.center,
        width: 103,
        height: 37,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
