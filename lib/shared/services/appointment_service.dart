import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cure_link/shared/models/appointment_model.dart';
import 'package:intl/intl.dart';

class AppointmentService {
  AppointmentService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<String> createAppointment({
    required String doctorId,
    required String doctorName,
    required String doctorImage,
    required String doctorEmail,
    required String patientId,
    required String patientName,
    required String patientImage,
    required String patientEmail,
    required String painDescription,
    required double price,
    required DateTime scheduledDateTime,
    String? clinicId,
    String? clinicName,
  }) async {
    final docRef = _firestore.collection('appointments').doc();
    final appointment = AppointmentModel(
      id: docRef.id,
      doctorId: doctorId,
      doctorName: doctorName,
      doctorImage: doctorImage,
      patientId: patientId,
      patientName: patientName,
      patientImage: patientImage,
      patientEmail: patientEmail,
      painDescription: painDescription,
      price: price,
      status: 'waiting',
      scheduledAt: Timestamp.fromDate(scheduledDateTime),
      createdAt: Timestamp.now(),
    );

    final appointmentData = appointment.toMap()
      ..addAll({
        'doctorEmail': doctorEmail,
        'updatedAt': FieldValue.serverTimestamp(),
        if (clinicId != null) 'clinicId': clinicId,
        if (clinicName != null) 'clinicName': clinicName,
      });

    // Write to main appointments collection (for real-time queue)
    await docRef.set(appointmentData);

    // Write to patient's appointments subcollection
    await _firestore
        .collection('users')
        .doc(patientId)
        .collection('appointments')
        .doc(docRef.id)
        .set(appointmentData);

    // Write to doctor's appointments subcollection
    await _firestore
        .collection('doctors')
        .doc(doctorId)
        .collection('appointments')
        .doc(docRef.id)
        .set(appointmentData);

    // Attach / update patient reference under the doctor profile
    final patientRef = _firestore
        .collection('doctors')
        .doc(doctorId)
        .collection('patients')
        .doc(patientId);

    await patientRef.set({
      'patientId': patientId,
      'patientName': patientName,
      'patientImage': patientImage,
      'patientEmail': patientEmail,
      'lastVisit': Timestamp.fromDate(scheduledDateTime),
      'lastReason': painDescription,
      'preferredClinic': clinicName ?? '',
      'totalVisits': FieldValue.increment(1),
    }, SetOptions(merge: true));

    return docRef.id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> patientAppointments(
    String patientId,
  ) {
    return _firestore
        .collection('users')
        .doc(patientId)
        .collection('appointments')
        .orderBy('scheduledAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> doctorAppointments(
    String doctorId,
  ) {
    return _firestore
        .collection('doctors')
        .doc(doctorId)
        .collection('appointments')
        .orderBy('scheduledAt')
        .snapshots();
  }

  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) async {
    final data = {
      'status': status,
      'statusUpdatedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Update main appointments collection
    await _firestore
        .collection('appointments')
        .doc(appointmentId)
        .set(data, SetOptions(merge: true));

    // Get appointment to find patient and doctor IDs
    final appointmentDoc =
        await _firestore.collection('appointments').doc(appointmentId).get();
    if (appointmentDoc.exists) {
      final appointmentData = appointmentDoc.data()!;
      final patientId = appointmentData['patientId'] as String?;
      final doctorId = appointmentData['doctorId'] as String?;

      // Update in patient's subcollection
      if (patientId != null) {
        await _firestore
            .collection('users')
            .doc(patientId)
            .collection('appointments')
            .doc(appointmentId)
            .set(data, SetOptions(merge: true));
      }

      // Update in doctor's subcollection
      if (doctorId != null) {
        await _firestore
            .collection('doctors')
            .doc(doctorId)
            .collection('appointments')
            .doc(appointmentId)
            .set(data, SetOptions(merge: true));
      }
    }
  }

  DateTime buildScheduledDateTime({
    required String dateLabel,
    required String timeLabel,
  }) {
    final year = DateTime.now().year;
    final date =
        DateFormat('EEE, MMM d y').parse('$dateLabel $year', true).toLocal();
    final time = DateFormat('hh:mm a').parse(timeLabel, true).toLocal();
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
}

