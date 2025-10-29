import 'package:cure_link/models/cubits/login_sigin_cubits/login_sigin_cubits.dart';
import 'package:cure_link/models/cubits/login_sigin_cubits/login_sigin_cubits_state.dart';
import 'package:cure_link/screens/sigin_screen/sig_in_screen.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/utils/app_icons.dart';
import 'package:cure_link/utils/app_validation.dart';
import 'package:cure_link/widgets/custom_bottom.dart';
import 'package:cure_link/widgets/custom_login_withe.dart';
import 'package:cure_link/widgets/custom_navigation_bar.dart';
import 'package:cure_link/widgets/custom_or_line.dart';
import 'package:cure_link/widgets/custom_show_snack_bar.dart';
import 'package:cure_link/widgets/custom_text_from_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  bool _isDialogShowing = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Login',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<LoginSiginCubits, LoginSiginCubitsState>(
        listener: (context, state) {
          if (state is LoginSiginCubitsLoading) {
            if (!_isDialogShowing) {
              _isDialogShowing = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    Center(child: CircularProgressIndicator()),
              );
            }
            return;
          }
          if (_isDialogShowing) {
            _isDialogShowing = false;
            Navigator.of(context, rootNavigator: true).pop();
          }

          if (state is LoginSiginCubitsSuccess) {
            CustomShowSnackBar(
              seconds: 1,
              context: context,
              message: 'Login Successful',
            ).build(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CustomNavigationBar()),
            );
          } else if (state is LoginSiginCubitsFailure) {
            CustomShowSnackBar(
              context: context,
              message: state.errorMessage,
              seconds: 3,
              backgroundColor: Colors.red,
              iconData: Icons.error_outline,
            ).build(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 15),
                  CustomTextFormField(
                    hintText: 'Enter your email',
                    controller: emailController,
                    prefixIcon: Icon(Icons.email, color: AppColor.greyColor),
                    validator: (p0) {
                      return AppValidation.validation(
                        value: emailController.text,
                        type: ValidationType.email,
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  CustomTextFormField(
                    hintText: 'Enter your password',
                    controller: passwordController,
                    prefixIcon: Icon(Icons.lock, color: AppColor.greyColor),
                    obscureText: obscureText,
                    validator: (p0) {
                      return AppValidation.validation(
                        value: passwordController.text,
                        type: ValidationType.password,
                      );
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off,
                        color: AppColor.greyColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: AppColor.greenColor),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: 'Login',
                    buttonWidth: double.infinity,
                    buttonHeight: 56,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (formKey.currentState!.validate()) {
                        // call cubit and wait for BlocListener to handle success/failure/navigation
                        BlocProvider.of<LoginSiginCubits>(
                          context,
                        ).loginWitheFirebase(
                          emailController.text,
                          passwordController.text,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(color: Color(0xFF6B7280)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
                        child: Text(
                          ' Sign Up',
                          style: TextStyle(color: AppColor.greenColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  CustomOrLine(),
                  SizedBox(height: 24),
                  CustomLoginWithe(
                    icons: AppIcons.google,
                    text: 'Login with Google',
                  ),
                  SizedBox(height: 16),
                  CustomLoginWithe(
                    icons: AppIcons.facebook,
                    text: 'Login with Facebook',
                  ),
                  SizedBox(height: 16),
                  CustomLoginWithe(
                    icons: AppIcons.apple,
                    text: 'Login with Apple',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
