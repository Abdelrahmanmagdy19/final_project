import 'package:cure_link/features/doctor/screens/doctor_clinics_screen.dart';
import 'package:cure_link/features/doctor/screens/doctor_queue_screen.dart';
import 'package:cure_link/features/doctor/screens/doctor_prescriptions_screen.dart';
import 'package:cure_link/features/doctor/services/doctor_repository.dart';
import 'package:cure_link/features/patient/screens/lets_get_started_screen/lets_get_started_screen.dart';
import 'package:cure_link/models/cubits/profile_cubits/profile_cubit.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/widgets/custom_divider.dart';
import 'package:cure_link/widgets/custom_row_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorId = FirebaseAuth.instance.currentUser?.uid;
    final DoctorRepository _repository = DoctorRepository();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: doctorId == null
            ? _buildEmptyState(context)
            : StreamBuilder(
                stream: _repository.doctorProfileStream(doctorId),
                builder: (context, snapshot) {
                  // Handle loading state
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Handle error state
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 48, color: Colors.red[300]),
                          const SizedBox(height: 12),
                          Text(
                            'Error loading profile: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.greenColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final data =
                      snapshot.data?.data() ?? <String, dynamic>{};
                  final userName = data['name'] ?? 'Doctor';
                  final profileImageUrl = data['imageUrl'] ??
                      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww&fm=jpg&q=60&w=3000';

                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/36_Profile.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(profileImageUrl)
                              as ImageProvider,
                          onBackgroundImageError: (_, __) {},
                        ),
                        const SizedBox(height: 19),
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: ListView(
                              children: [
                                CustomRowProfileScreen(
                                  iconData: Icons.local_hospital_outlined,
                                  title: 'Clinics & Schedule',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DoctorClinicsScreen(),
                                      ),
                                    );
                                  },
                                ),
                                const CustomDivider(),
                                CustomRowProfileScreen(
                                  iconData: Icons.list_alt_outlined,
                                  title: 'Live Queue',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DoctorQueueScreen(),
                                      ),
                                    );
                                  },
                                ),
                                const CustomDivider(),
                                CustomRowProfileScreen(
                                  iconData: Icons.medical_services_outlined,
                                  title: 'Prescriptions',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DoctorPrescriptionsScreen(),
                                      ),
                                    );
                                  },
                                ),
                                const CustomDivider(),
                                CustomRowProfileScreen(
                                  iconData: Icons.settings_outlined,
                                  title: 'Settings',
                                  onTap: () {},
                                ),
                                const CustomDivider(),
                                CustomRowProfileScreen(
                                  iconData: Icons.logout,
                                  title: 'Log Out',
                                  onTap: () async {
                                    final route = MaterialPageRoute(
                                      builder: (context) =>
                                          const LetsGetStarted(),
                                    );

                                    await context.read<ProfileCubit>().logout();

                                    if (!context.mounted) {
                                      return;
                                    }

                                    Navigator.pushReplacement(context, route);
                                  },
                                  backgroundColor: Colors.red.shade100,
                                  iconColor: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_off_outlined,
                color: AppColor.greenColor, size: 48),
            const SizedBox(height: 12),
            const Text(
              'No authenticated doctor found.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

