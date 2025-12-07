import 'package:cure_link/utils/app_color.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.buttonWidth,
    required this.buttonHeight,
    this.onTap,
    this.buttonColor = AppColor.greenColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(32)),
    this.textColor = Colors.white,
  });
  final String text;
  final double buttonWidth;
  final double buttonHeight;
  final void Function()? onTap;
  final Color? buttonColor;
  final BorderRadiusGeometry? borderRadius;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: buttonWidth,
        height: buttonHeight,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: borderRadius,
        ),
        child: Text(text, style: TextStyle(color: textColor, fontSize: 16)),
      ),
    );
  }
}
