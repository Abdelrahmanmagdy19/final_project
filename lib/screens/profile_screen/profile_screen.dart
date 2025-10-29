import 'package:cure_link/models/cubits/profile_cubits/profile_cubit.dart';
import 'package:cure_link/models/cubits/profile_cubits/profile_state.dart';
import 'package:cure_link/screens/lets_get_started_screen/lets_get_started_screen.dart';
import 'package:cure_link/widgets/custom_divider.dart';
import 'package:cure_link/widgets/custom_row_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().fetchProfileData();

    return Scaffold(
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          String userName = 'Loading...';
          String profileImageUrl =
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww&fm=jpg&q=60&w=3000';
          String? userRole;
          bool isLoading = false;

          if (state is ProfileLoading) {
            userName = 'Loading...';
            isLoading = true;
          } else if (state is ProfileLoaded) {
            userName = state.profile.name;
            profileImageUrl = state.profile.imageUrl;
            userRole = state.profile.role;
          } else if (state is ProfileError) {
            return Center(child: Text('Error: ${state.message}'));
          }

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
                  backgroundImage: isLoading
                      ? null
                      : NetworkImage(profileImageUrl) as ImageProvider,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : null,
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
                          iconData: Icons.favorite_border,
                          title: 'Favorites',
                          onTap: () {},
                        ),
                        const CustomDivider(),
                        CustomRowProfileScreen(
                          iconData: Icons.calendar_today_outlined,
                          title: 'Appointment',
                          onTap: () {},
                        ),
                        const CustomDivider(),
                        CustomRowProfileScreen(
                          iconData: Icons.payment_outlined,
                          title: 'Payment Methods',
                          onTap: () {},
                        ),
                        const CustomDivider(),
                        CustomRowProfileScreen(
                          iconData: Icons.help_outline,
                          title: 'FAQs',
                          onTap: () {},
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
                              builder: (context) => const LetsGetStarted(),
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
    );
  }
}
