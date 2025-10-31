import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/widgets/custom_bottom.dart';
import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String? _userRole;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    if (currentUser == null) return;

    final doctorDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(currentUser!.uid)
        .get();

    if (doctorDoc.exists) {
      setState(() {
        _userRole = 'doctor';
      });
      return;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        _userRole = 'user';
      });
      return;
    }

    setState(() {
      _userRole = 'unknown';
    });
  }

  Stream<QuerySnapshot> _getAppointmentsStream() {
    if (currentUser == null || _userRole == null || _userRole == 'unknown') {
      return Stream.empty();
    }

    String fieldToFilterBy = _userRole == 'doctor' ? 'doctorUid' : 'userUid';

    return FirebaseFirestore.instance
        .collection('Schedule')
        .where(fieldToFilterBy, isEqualTo: currentUser!.uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Schedule Screen',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.schedule, color: AppColor.greenColor, size: 28),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _userRole == null
            ? const Center(child: CircularProgressIndicator())
            : StreamBuilder<QuerySnapshot>(
                stream: _getAppointmentsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    String indexField = _userRole == 'doctor'
                        ? 'doctorUid'
                        : 'userUid';
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 40,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Failed to load appointments. Please ensure the Composite Index for **`$indexField`** is built in Firebase.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'You have no appointments booked ${_userRole == 'doctor' ? 'with you.' : 'yet.'}',
                      ),
                    );
                  }

                  final appointments = snapshot.data!.docs;

                  return ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot doc = appointments[index];
                      final appointment = doc.data() as Map<String, dynamic>;

                      final String primaryName = _userRole == 'doctor'
                          ? (appointment['userName'] ?? 'Patient N/A')
                          : (appointment['doctorName'] ?? 'Doctor N/A');

                      final String secondaryText = _userRole == 'doctor'
                          ? 'Patient'
                          : (appointment['doctorSpecialization'] ?? 'N/A');

                      final String imageURL = _userRole == 'doctor'
                          ? (appointment['userImage'] ??
                                'https://via.placeholder.com/150')
                          : (appointment['doctorImage'] ??
                                'https://via.placeholder.com/150');

                      final appointmentDate =
                          appointment['appointmentDate'] ?? 'N/A';
                      final appointmentTime =
                          appointment['appointmentTime'] ?? 'N/A';
                      final status = appointment['status'] ?? 'N/A';

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppColor.greyColor),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        primaryName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        secondaryText,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.lightGreyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(flex: 1),
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(imageURL),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$appointmentDate | $appointmentTime',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Status: $status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: status == 'Confirmed'
                                          ? AppColor.greenColor
                                          : status == 'Cancelled'
                                          ? Colors.red
                                          : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(
                                    text: 'Cancel',
                                    buttonWidth: 145,
                                    buttonHeight: 46,
                                    borderRadius: BorderRadius.circular(8),
                                    buttonColor: AppColor.lightGreenColor,
                                    textColor: Colors.black,
                                  ),
                                  CustomButton(
                                    text: 'Reschedule',
                                    buttonWidth: 145,
                                    buttonHeight: 46,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
