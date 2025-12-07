import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/utils/app_validation.dart';
import 'package:cure_link/widgets/custom_bottom.dart';
import 'package:cure_link/widgets/custom_text_from_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> sendResetEmail() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Password reset link sent successfully! Check your inbox.',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColor.greenColor,
          ),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      final String errorMessage = (e.code == 'user-not-found')
          ? 'The email is not registered.'
          : (e.message ?? 'An unknown error occurred.');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text(errorMessage)),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('An unknown error occurred.')),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/forgot_password.png'),
                  ),
                ),
              ),
              const Text(
                'Forgot Your Password?',
                style: TextStyle(
                  fontFamily: 'inter',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your email, we will send you a link to reset your password.',
                style: TextStyle(
                  fontFamily: 'inter',
                  fontSize: 16,
                  color: AppColor.darkGreyColor,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextFormField(
                hintText: 'Enter your email',
                controller: emailController,
                validator: (p0) {
                  return AppValidation.validation(
                    value: emailController.text,
                    type: ValidationType.email,
                  );
                },
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email, color: AppColor.greenColor),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: _isLoading ? 'Sending...' : 'Send',
                buttonWidth: double.infinity,
                buttonHeight: 56,
                onTap: _isLoading ? null : sendResetEmail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
