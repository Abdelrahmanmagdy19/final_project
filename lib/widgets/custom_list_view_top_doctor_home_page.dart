import 'package:cure_link/models/model/doctors_details_model.dart';
import 'package:cure_link/services/get_data_from_firebase_top_doctor.dart';
import 'package:cure_link/widgets/custom_top_doctors_container_home_page.dart';
import 'package:flutter/material.dart';

class CustomListViewTopDoctorHomePage extends StatelessWidget {
  const CustomListViewTopDoctorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 173,
      child: FutureBuilder<List<DoctorsDetailsModel>>(
        future: GetDataFromFirebaseTopDoctor().fetchTopDoctors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final List<DoctorsDetailsModel> doctors = List.from(snapshot.data!);

            doctors.sort((a, b) {
              final double ratingA = a.totalRating ?? 0.0;
              final double ratingB = b.totalRating ?? 0.0;
              return ratingB.compareTo(ratingA);
            });

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: CustomTopDoctorsContainerHomePage(
                    topDoctorsModel: doctor,
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No top doctors found.'));
          }
        },
      ),
    );
  }
}
