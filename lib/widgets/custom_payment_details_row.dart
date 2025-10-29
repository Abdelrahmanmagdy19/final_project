import 'package:cure_link/utils/app_color.dart';
import 'package:flutter/material.dart';

class CustomPaymentDetailsRow extends StatelessWidget {
  const CustomPaymentDetailsRow({
    super.key,
    required this.text,
    required this.price,
    this.color = Colors.black,
  });

  final String text;
  final String price;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(color: AppColor.darkGreyColor, fontSize: 14),
          ),
          Text(price, style: TextStyle(color: color, fontSize: 14)),
        ],
      ),
    );
  }
}
