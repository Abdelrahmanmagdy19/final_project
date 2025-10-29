import 'package:cure_link/models/cubits/login_sigin_cubits/login_sigin_cubits.dart';
import 'package:cure_link/models/cubits/login_sigin_cubits/login_sigin_cubits_state.dart';
import 'package:cure_link/screens/login_screen/login_screen.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/utils/app_validation.dart';
import 'package:cure_link/widgets/custom_bottom.dart';
import 'package:cure_link/widgets/custom_navigation_bar.dart';
import 'package:cure_link/widgets/custom_show_snack_bar.dart';
import 'package:cure_link/widgets/custom_text_from_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController specializationController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool obscureText = true;
  bool isChecked = false;
  bool _isDialogShowing = false;
  String? _selectedRole;
  final List<String> _roles = ['user', 'doctor', 'pharmacy', 'hospital'];

  bool _isDoctorRole() => _selectedRole == 'doctor';
  bool _isOrganizationRole() =>
      _selectedRole == 'pharmacy' || _selectedRole == 'hospital';

  void _handleSignUp() async {
    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 15),
              Text(
                'Please accept Terms of Service',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 15),
              Text(
                'Please select your role',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }
    if (formKey.currentState!.validate()) {
      BlocProvider.of<LoginSiginCubits>(context).registerWithFirebase(
        nameController.text,
        emailController.text,
        passwordController.text,
        imageUrlController.text,
        _selectedRole!,
        specializationController.text,
        experienceController.text,
        aboutController.text,
        priceController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Sign In',
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
                    const Center(child: CircularProgressIndicator()),
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
              message: 'Registration Successful',
            ).build(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CustomNavigationBar(),
              ),
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
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    hintText: _isOrganizationRole()
                        ? 'Enter organization name'
                        : 'Enter your name',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: AppColor.greyColor,
                    ),
                    controller: nameController,
                    validator: (p0) {
                      return AppValidation.validation(
                        value: nameController.text,
                        type: ValidationType.name,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    hintText: 'Enter Profile Image URL',
                    prefixIcon: Icon(Icons.link, color: AppColor.greyColor),
                    controller: imageUrlController,
                    validator: (p0) {
                      return AppValidation.validation(
                        value: p0!,
                        type: ValidationType.url,
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  CustomTextFormField(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppColor.greyColor,
                    ),
                    controller: emailController,
                    validator: (p0) {
                      return AppValidation.validation(
                        value: emailController.text,
                        type: ValidationType.email,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    hintText: 'Enter your password',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppColor.greyColor,
                    ),
                    controller: passwordController,
                    validator: (p0) {
                      return AppValidation.validation(
                        value: passwordController.text,
                        type: ValidationType.password,
                      );
                    },
                    obscureText: obscureText,
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
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Select Role',
                      prefixIcon: Icon(Icons.group, color: AppColor.greyColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColor.greyColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColor.greenColor),
                      ),
                    ),
                    value: _selectedRole,
                    items: _roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue;
                        specializationController.clear();
                        experienceController.clear();
                        aboutController.clear();
                        priceController.clear();
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a role';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_isDoctorRole()) ...[
                    CustomTextFormField(
                      hintText: 'Enter your Specialization',
                      prefixIcon: Icon(
                        Icons.local_hospital_outlined,
                        color: AppColor.greyColor,
                      ),
                      controller: specializationController,
                      validator: (p0) {
                        return AppValidation.validation(
                          value: specializationController.text,
                          type: ValidationType.name,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      hintText: 'Tell us about yourself (Bio/About)',
                      prefixIcon: Icon(
                        Icons.info_outline,
                        color: AppColor.greyColor,
                      ),
                      controller: aboutController,
                      maxLines: 3,
                      validator: (p0) {
                        return AppValidation.validation(
                          value: aboutController.text,
                          type: ValidationType.about,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      hintText: 'Consultation Price (e.g., 50.00)',
                      prefixIcon: Icon(
                        Icons.attach_money,
                        color: AppColor.greyColor,
                      ),
                      controller: priceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (p0) {
                        return AppValidation.validation(
                          value: priceController.text,
                          type: ValidationType.number,
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    CustomTextFormField(
                      hintText: 'Years of Experience',
                      prefixIcon: Icon(
                        Icons.history_toggle_off,
                        color: AppColor.greyColor,
                      ),
                      controller: experienceController,
                      keyboardType: TextInputType.number,
                      validator: (p0) {
                        return AppValidation.validation(
                          value: experienceController.text,
                          type: ValidationType.number,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'I agree to the medidoc Terms of Service and Privacy Policy',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Sign Up',
                    buttonWidth: double.infinity,
                    buttonHeight: 56,
                    onTap: _handleSignUp,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Or do you have an account? ',
                        style: TextStyle(color: Color(0xFF6B7280)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          ' Login',
                          style: TextStyle(
                            color: AppColor.greenColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
