import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cure_link/features/doctor/services/doctor_repository.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorPatientsScreen extends StatelessWidget {
  const DoctorPatientsScreen({super.key});

  static final DoctorRepository _repository = DoctorRepository();

  @override
  Widget build(BuildContext context) {
    final doctorId = FirebaseAuth.instance.currentUser?.uid;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Patients'),
          centerTitle: true,
        ),
        body: doctorId == null
            ? const Center(child: Text('Login required to view patients.'))
            : StreamBuilder(
                stream: _repository.patientsStream(doctorId),
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
                              size: 60, color: Colors.red[300]),
                          const SizedBox(height: 12),
                          Text(
                            'Error loading patients',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
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

                  // Handle empty state
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline,
                              size: 60, color: AppColor.greenColor),
                          const SizedBox(height: 12),
                          const Text(
                            'No patients assigned yet.',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data();
                      final timestamp = data['lastVisit'] as Timestamp?;
                      final lastVisit = timestamp != null
                          ? DateFormat('EEE, MMM d • hh:mm a')
                              .format(timestamp.toDate())
                          : 'Not recorded';
                      final totalVisits = (data['totalVisits'] as num?)?.toInt() ?? 1;
                      return _PatientCard(
                        name: data['patientName'] ?? 'Unnamed',
                        email: data['patientEmail'] ?? '',
                        lastVisit: lastVisit,
                        totalVisits: totalVisits,
                        onTap: () => _openPatientFile(
                          context,
                          data,
                          docs[index].id,
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  void _openPatientFile(
    BuildContext context,
    Map<String, dynamic> data,
    String patientId,
  ) {
    final timestamp = data['lastVisit'] as Timestamp?;
    final lastVisit = timestamp != null
        ? DateFormat('EEE, MMM d, yyyy • hh:mm a').format(timestamp.toDate())
        : 'Not recorded';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data['patientName'] ?? 'Patient File',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Patient ID: $patientId',
                    style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 4),
                if (data['patientEmail'] != null &&
                    (data['patientEmail'] as String).isNotEmpty)
                  Text(
                    data['patientEmail'],
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                const SizedBox(height: 16),
                _SectionTitle(title: 'Latest Visit'),
                _InfoRow(
                  label: 'Last visit',
                  value: lastVisit,
                ),
                _InfoRow(
                  label: 'Total visits',
                  value: (data['totalVisits'] ?? 1).toString(),
                ),
                _InfoRow(
                  label: 'Reason',
                  value: data['lastReason'] ?? 'Not provided',
                ),
                _InfoRow(
                  label: 'Clinic',
                  value: (data['preferredClinic'] as String?)?.isNotEmpty == true
                      ? data['preferredClinic']
                      : 'Not specified',
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PatientCard extends StatelessWidget {
  final String name;
  final String email;
  final String lastVisit;
  final int totalVisits;
  final VoidCallback onTap;

  const _PatientCard({
    required this.name,
    required this.email,
    required this.lastVisit,
    required this.totalVisits,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColor.greenColor.withOpacity(0.15),
              child: Text(
                name.isNotEmpty ? name[0] : '?',
                style: TextStyle(
                  color: AppColor.greenColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (email.isNotEmpty)
                    Text(
                      email,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    'Visits: $totalVisits',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last visit: $lastVisit',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

