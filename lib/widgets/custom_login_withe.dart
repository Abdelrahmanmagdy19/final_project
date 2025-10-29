import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomLoginWithe extends StatelessWidget {
  const CustomLoginWithe({super.key, required this.icons, required this.text});
  final String icons;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 18),
          SvgPicture.asset(icons),
          SizedBox(width: 54),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
