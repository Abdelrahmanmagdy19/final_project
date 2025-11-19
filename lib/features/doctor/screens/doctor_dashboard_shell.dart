import 'package:cure_link/features/doctor/screens/doctor_chat_screen.dart';
import 'package:cure_link/features/doctor/screens/doctor_overview_screen.dart';
import 'package:cure_link/features/doctor/screens/doctor_patients_screen.dart';
import 'package:cure_link/features/doctor/screens/doctor_profile_screen.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class DoctorDashboardShell extends StatefulWidget {
  const DoctorDashboardShell({super.key});

  @override
  State<DoctorDashboardShell> createState() => _DoctorDashboardShellState();
}

class _DoctorDashboardShellState extends State<DoctorDashboardShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DoctorOverviewScreen(),
    DoctorChatScreen(),
    DoctorPatientsScreen(),
    DoctorProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        color: AppColor.greenColor.withValues(alpha: 0.06),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SafeArea(
          child: GNav(
            gap: 8,
            activeColor: AppColor.greenColor,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            duration: const Duration(milliseconds: 250),
            tabBackgroundColor: AppColor.greenColor.withValues(alpha: 0.08),
            color: Colors.grey[600],
            selectedIndex: _currentIndex,
            onTabChange: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
            tabs: const [
              GButton(icon: Icons.dashboard_outlined, text: 'Overview'),
              GButton(icon: Icons.chat_bubble_outline, text: 'Messages'),
              GButton(icon: Icons.people_alt_outlined, text: 'Patients'),
              GButton(icon: Icons.person_outline, text: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}

