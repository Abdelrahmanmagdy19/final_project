
import 'package:cure_link/screens/fogetPassword_screens/verify_code.dart';
import 'package:flutter/material.dart';

import '../../utils/app_color.dart';
import '../../widgets/custom_bottom.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_from_field.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  bool isPassword = false;
  bool isConfirmPassword = false;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool validateEmail(String email) {
    return RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios),
              ),

              const SizedBox(height: 15),

              const CustomText(
                text: "Create New Password?",
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 8),

              const CustomText(
                text: "Create your new password to login.",
                color: AppColor.greyColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),

              const SizedBox(height: 25),

              CustomTextFormField(
                obscureText: !isPassword,
                controller: passwordController,
                hintText: 'Enter your new password',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.asset(
                    "Assets/Icons/passwordIcon.png",
                    width: 25,
                    height: 25,
                  ),
                ),
                textInputType: TextInputType.text,
                onChanged: (value) {},
                suffixIcon: IconButton(
                  icon: Icon(
                    isPassword ? Icons.visibility : Icons.visibility_off,
                    color: isPassword ? AppColor.greenColor : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isPassword = !isPassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 25),

              CustomTextFormField(
                obscureText: !isConfirmPassword,
                controller: confirmPasswordController,
                hintText: 'Confirm password',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.asset(
                    "Assets/Icons/passwordIcon.png",
                    width: 25,
                    height: 25,
                  ),
                ),
                textInputType: TextInputType.text,
                onChanged: (value) {},
                suffixIcon: IconButton(
                  icon: Icon(
                    isConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    color: isConfirmPassword ? AppColor.greenColor : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isConfirmPassword = !isConfirmPassword;
                    });
                  },
                ),
              ),

              const SizedBox(height: 40),

              CustomButton(
                text: 'Create Password',
                buttonWidth: double.infinity,
                buttonHeight: 60,
                onTap: () {
                  if (passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in both password fields')),
                    );
                    return;
                  }

                  if (passwordController.text != confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VerifyCode()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
