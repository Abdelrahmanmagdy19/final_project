import 'package:cure_link/models/cubits/top_doctor_cubit/top_doctor_cubit.dart';
import 'package:cure_link/models/cubits/top_doctor_cubit/top_doctor_cubit_state.dart';
import 'package:cure_link/models/model/doctors_details_model.dart';
import 'package:cure_link/screens/doctor_details_screen/doctor_details_screen.dart';
import 'package:cure_link/widgets/custom_top_doctor_page_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopDoctorScreen extends StatelessWidget {
  const TopDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Top Doctors',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<TopDoctorCubit, TopDoctorCubitState>(
        builder: (context, state) {
          if (state is TopDoctorCubitLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TopDoctorCubitSuccess) {
            final List<DoctorsDetailsModel> sortedDoctors = List.from(
              state.doctors,
            );
            sortedDoctors.sort((a, b) {
              final double ratingA = a.totalRating ?? 0.0;
              final double ratingB = b.totalRating ?? 0.0;
              return ratingB.compareTo(ratingA);
            });
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: sortedDoctors.length,
              itemBuilder: (context, index) {
                final doctor = sortedDoctors[index];
                return CustomTopDoctorPageContainer(
                  doctor: doctor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DoctorDetailsScreen(doctor: doctor),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is TopDoctorCubitFailure) {
            return Center(
              child: Text(
                'Failed to load doctors: ${state.errorMessage}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
          return const Center(
            child: Text('Press refresh or go back to load data.'),
          );
        },
      ),
    );
  }
}
