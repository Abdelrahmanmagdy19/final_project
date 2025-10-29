
import 'package:cure_link/screens/fogetPassword_screens/verify_code.dart';
import 'package:flutter/material.dart';

import '../../utils/app_color.dart';
import '../../widgets/custom_bottom.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_from_field.dart';
class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
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
                text: "Forget Your Password?",
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 8),

              const CustomText(
                text:
                    "Enter your email or phone number,\nand we’ll send you a confirmation code.",
                color: AppColor.greyColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),

              const SizedBox(height: 25),

              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.grey2Color,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isEmailSelected = true),
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: isEmailSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: isEmailSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: const Center(
                            child: Text(
                              'E-mail',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isEmailSelected = false),
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: !isEmailSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: !isEmailSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: const Center(
                            child: Text(
                              'Phone',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              CustomTextFormField(
                controller: isEmailSelected ? emailController : phoneController,
                hintText: isEmailSelected
                    ? 'Enter your email'
                    : 'Enter your phone number',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(15),
                  child: isEmailSelected
                      ? Image.asset(
                          "Assets/Icons/emailIcon.png",
                          width: 25,
                          height: 25,
                        )
                      : Image.asset(
                          "Assets/Icons/phoneIcon.png",
                          width: 25,
                          height: 25,
                        ),
                ),
                textInputType: isEmailSelected
                    ? TextInputType.emailAddress
                    : TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    if (isEmailSelected) {
                      isEmailValid = validateEmail(value!);
                    } else {
                      isPhoneValid = validatePhone(value!);
                    }
                  });
                },
                suffixIcon: Icon(
                  (isEmailSelected ? isEmailValid : isPhoneValid)
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: (isEmailSelected ? isEmailValid : isPhoneValid)
                      ? Colors.green
                      : Colors.red,
                ),
              ),

              const SizedBox(height: 40),

              // Reset Button
              CustomButton(
                text: 'Reset Password',
                buttonWidth: double.infinity,
                buttonHeight: 60,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyCode()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
