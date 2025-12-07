import 'package:cure_link/shared/models/doctors_details_model.dart';
import 'package:cure_link/features/patient/screens/doctor_details_screen/doctor_details_screen.dart';
import 'package:cure_link/services/get_data_from_firebase_top_doctor.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/widgets/custom_text_from_field.dart';
import 'package:cure_link/widgets/custom_top_doctor_page_container.dart';
import 'package:flutter/material.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final GetDataFromFirebaseTopDoctor _doctorService =
      GetDataFromFirebaseTopDoctor();
  late Future<List<DoctorsDetailsModel>> _doctorsFuture;

  List<DoctorsDetailsModel> _allDoctors = [];

  List<DoctorsDetailsModel> _filteredDoctors = [];

  final TextEditingController _searchController = TextEditingController();

  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _doctorsFuture = _fetchDoctors();
  }

  Future<List<DoctorsDetailsModel>> _fetchDoctors() async {
    try {
      final doctors = await _doctorService.fetchTopDoctors();
      _allDoctors = doctors;
      return doctors;
    } catch (e) {
      rethrow;
    }
  }

  void _onSearchSubmitted(String query) {
    final searchQuery = query.toLowerCase().trim();

    if (_allDoctors.isEmpty) {
      setState(() {
        _filteredDoctors = [];
        _hasSearched = true;
      });
      return;
    }

    setState(() {
      _hasSearched = true;

      if (searchQuery.isEmpty) {
        _filteredDoctors = [];
      } else {
        _filteredDoctors = _allDoctors.where((doctor) {
          final nameLower = doctor.name?.toLowerCase() ?? '';
          final specialtyLower = doctor.specialty?.toLowerCase() ?? '';

          return nameLower.contains(searchQuery) ||
              specialtyLower.contains(searchQuery);
        }).toList();

        _filteredDoctors.sort((a, b) {
          final double ratingA = a.totalRating ?? 0.0;
          final double ratingB = b.totalRating ?? 0.0;

          return ratingB.compareTo(ratingA);
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctors',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: CustomTextFormField(
              controller: _searchController,

              hintText: 'Search by Name or Specialty',
              onSaved: (p0) {},
              onFieldSubmitted: _onSearchSubmitted,
              suffixIcon: IconButton(
                icon: const Icon(Icons.search, color: AppColor.greenColor),
                onPressed: () {
                  _onSearchSubmitted(_searchController.text);
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<DoctorsDetailsModel>>(
              future: _doctorsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Failed to load doctor data: ${snapshot.error}',
                    ),
                  );
                }

                if (!_hasSearched) {
                  return const Center(
                    child: Text('Enter a doctor name or specialty to search.'),
                  );
                }

                if (_filteredDoctors.isEmpty) {
                  return const Center(
                    child: Text(
                      'No matching doctors found. Try a different search term.',
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: _filteredDoctors.length,
                  itemBuilder: (context, index) {
                    final doctor = _filteredDoctors[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CustomTopDoctorPageContainer(
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
