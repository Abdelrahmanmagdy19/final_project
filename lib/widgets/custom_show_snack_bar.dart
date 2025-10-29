import 'package:cure_link/utils/app_color.dart';
import 'package:flutter/material.dart';

class CustomShowSnackBar extends StatelessWidget {
  const CustomShowSnackBar({
    super.key,
    required this.context,
    this.backgroundColor = AppColor.greenColor,
    this.iconData = Icons.check_circle,
    required this.message,
    required this.seconds,
  });
  final BuildContext context;
  final Color? backgroundColor;
  final IconData? iconData;
  final String message;
  final int seconds;
  @override
  build(BuildContext context) async {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        duration: Duration(seconds: seconds),
        content: Row(
          children: [
            Icon(iconData, color: Colors.white),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
