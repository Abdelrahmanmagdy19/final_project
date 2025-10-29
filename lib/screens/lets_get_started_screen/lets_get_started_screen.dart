import 'package:cure_link/screens/login_screen/login_screen.dart';
import 'package:cure_link/screens/sigin_screen/sig_in_screen.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/utils/app_images.dart';
import 'package:cure_link/widgets/custom_bottom.dart';
import 'package:flutter/material.dart';

class LetsGetStarted extends StatelessWidget {
  const LetsGetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.splashScreenImage, scale: 2),
            Text(
              'Let\'s get started!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 9),
            Text(
              'Login to enjoy the features we’ve',
              style: TextStyle(fontSize: 16, color: Color(0xFF717784)),
            ),
            Text(
              'provided, and stay healthy!',
              style: TextStyle(fontSize: 16, color: Color(0xFF717784)),
            ),
            SizedBox(height: 60),
            CustomButton(
              text: 'Login',
              buttonWidth: 263,
              buttonHeight: 56,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignInScreen()),
              ),
              child: Container(
                alignment: Alignment.center,
                width: 263,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: AppColor.greenColor),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 16, color: AppColor.greenColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
