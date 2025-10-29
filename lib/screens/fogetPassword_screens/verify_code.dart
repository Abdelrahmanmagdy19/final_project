import '../../utils/app_color.dart';
import '../../widgets/custom_bottom.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/verify_code_field.dart';
import 'create_new_password.dart';
import 'package:flutter/material.dart';

class VerifyCode extends StatefulWidget {
  const VerifyCode({super.key});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  bool isEmailSelected = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isEmailValid = false;
  bool isPhoneValid = false;

  bool validateEmail(String email) {
    return RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool validatePhone(String phone) {
    return RegExp(r'^[0-9]{10,15}$').hasMatch(phone);
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
                text: "Enter verification code",
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 8),

              const CustomText(
                text: "Enter code that we have sent to your \nEmail Ahme******* .",
                color: AppColor.greyColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 60,

                child: VerifyCodeField(
                  onCompleted: (code) {
                    print(code);
                  },
                ),
              ),

              const SizedBox(height: 60),
              CustomButton(
                text: 'Verify',
                buttonWidth: double.infinity,
                buttonHeight: 60,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateNewPassword()));
                },
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Didn't receive the code?"),
                  TextButton(onPressed: () {}, child: Text("Resend",style: TextStyle(color: AppColor.greenColor),)),
                ],
              ),
              // Reset Button
            ],
          ),
        ),
      ),
    );
  }
}
