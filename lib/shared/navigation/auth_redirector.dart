import 'package:cure_link/features/doctor/screens/doctor_dashboard_shell.dart';
import 'package:cure_link/features/patient/screens/home_onboarding_screen/home_boarding_screen.dart';
import 'package:cure_link/shared/services/user_role_service.dart';
import 'package:cure_link/widgets/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthRedirector extends StatelessWidget {
  const AuthRedirector({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SplashLoader();
        }

        final user = snapshot.data;
        if (user == null) {
          return const HomeOnBoardingScreen();
        }

        return FutureBuilder<String>(
          future: UserRoleService().fetchUserRole(user.uid),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const _SplashLoader();
            }
            if (roleSnapshot.hasError) {
              return _ErrorScreen(
                message: roleSnapshot.error?.toString() ?? 'Unknown error',
              );
            }
            final role = roleSnapshot.data ?? 'patient';
            if (role.toLowerCase() == 'doctor') {
              return const DoctorDashboardShell();
            }
            return const CustomNavigationBar();
          },
        );
      },
    );
  }
}

class _SplashLoader extends StatelessWidget {
  const _SplashLoader();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  final String message;

  const _ErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

