import 'package:cure_link/utils/app_color.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.controller,
    this.suffixIcon,
    this.obscureText,
    this.validator,
    this.maxLines = 1,
    this.onSaved,
    this.keyboardType,
    this.textInputType,
    this.onChanged,
  });
  final String hintText;
  final TextEditingController? controller;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final void Function(String?)? onSaved;
  final TextInputType? textInputType;
  final Function(String?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onSaved: onSaved,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: TextStyle(color: AppColor.greyColor),
        fillColor: Color(0xFFF9FAFB),
        filled: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: AppColor.greyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: AppColor.greenColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: AppColor.greyColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
