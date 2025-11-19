import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cure_link/features/doctor/services/doctor_repository.dart';
import 'package:cure_link/shared/services/appointment_service.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorQueueScreen extends StatelessWidget {
  const DoctorQueueScreen({super.key});

  static final DoctorRepository _repository = DoctorRepository();
  static final AppointmentService _appointmentService = AppointmentService();

  Future<void> _updateStatus(String appointmentId, String status) async {
    await _appointmentService.updateAppointmentStatus(
      appointmentId: appointmentId,
      status: status,
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctorId = FirebaseAuth.instance.currentUser?.uid;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Live Queue'),
          centerTitle: true,
        ),
        body: doctorId == null
            ? const Center(child: Text('Login required to view queue.'))
            : StreamBuilder(
                stream: _repository.todaysQueueStream(doctorId),
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
                            'Error loading appointments',
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
                          Icon(Icons.hourglass_empty_outlined,
                              size: 60, color: AppColor.greenColor),
                          const SizedBox(height: 12),
                          const Text(
                            'No appointments scheduled today.',
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
                      final doc = docs[index];
                      final data = doc.data();
                      final patientName = data['patientName'] ?? 'Unknown';
                      final status = data['status'] ?? 'waiting';
                      final timestamp = data['scheduledAt'] as Timestamp?;
                      final time = timestamp != null
                          ? DateFormat('hh:mm a')
                              .format(timestamp.toDate())
                          : '--:--';
                      final clinicName = data['clinicName'] as String?;
                      final painDescription = data['painDescription'] as String?;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.grey[200]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  patientName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColor.greenColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    status.toUpperCase(),
                                    style: TextStyle(
                                      color: AppColor.greenColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 18, color: Colors.grey[600]),
                                const SizedBox(width: 6),
                                Text(
                                  time,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                if (clinicName != null) ...[
                                  const SizedBox(width: 16),
                                  Icon(Icons.local_hospital,
                                      size: 18, color: Colors.grey[600]),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      clinicName,
                                      style: TextStyle(color: Colors.grey[600]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (painDescription != null && painDescription.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.info_outline,
                                        size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        painDescription,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => _updateStatus(
                                      doc.id,
                                      'in-session',
                                    ),
                                    child: const Text('Start'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.greenColor,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () => _updateStatus(
                                      doc.id,
                                      'completed',
                                    ),
                                    child: const Text('Complete'),
                                  ),
                                ),
                              ],
                            )
                          ],
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

