import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class DoctorDashboardSummary {
  final int todayAppointments;
  final double todayRevenue;
  final double averageRating;

  const DoctorDashboardSummary({
    required this.todayAppointments,
    required this.todayRevenue,
    required this.averageRating,
  });

  const DoctorDashboardSummary.empty()
      : todayAppointments = 0,
        todayRevenue = 0,
        averageRating = 0;
}

class DoctorRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  DoctorRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> doctorProfileStream(
    String doctorId,
  ) {
    return _firestore.collection('doctors').doc(doctorId).snapshots();
  }

  Future<DoctorDashboardSummary> fetchDashboardSummary(String doctorId) async {
    try {
      final now = DateTime.now();
      final dayStart = DateTime(now.year, now.month, now.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      final appointmentsQuery = await _firestore
          .collection('doctors')
          .doc(doctorId)
          .collection('appointments')
          .where(
            'scheduledAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart),
          )
          .where(
            'scheduledAt',
            isLessThan: Timestamp.fromDate(dayEnd),
          )
          .orderBy('scheduledAt')
          .get()
          .timeout(const Duration(seconds: 10));

      final todayAppointments = appointmentsQuery.size;
      double revenue = 0;

      for (final doc in appointmentsQuery.docs) {
        final data = doc.data();
        final dynamic rawFee = data['fee'] ?? data['price'] ?? 0;
        revenue += (rawFee is num) ? rawFee.toDouble() : 0;
      }

      final profileSnap = await _firestore
          .collection('doctors')
          .doc(doctorId)
          .get()
          .timeout(const Duration(seconds: 10));

      double avgRating = 0;
      if (profileSnap.exists) {
        final data = profileSnap.data();
        if (data != null && data['averageRating'] != null) {
          final dynamic rating = data['averageRating'];
          avgRating = (rating is num) ? rating.toDouble() : 0;
        }
      }

      return DoctorDashboardSummary(
        todayAppointments: todayAppointments,
        todayRevenue: revenue,
        averageRating: avgRating,
      );
    } catch (e) {
      // Return empty summary on error instead of throwing
      return const DoctorDashboardSummary.empty();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> clinicsStream(
    String doctorId,
  ) {
    return _firestore
        .collection('clinics')
        .where('doctorId', isEqualTo: doctorId)
        .snapshots();
  }

  Future<void> addClinic({
    required String doctorId,
    required String clinicName,
    required String address,
    required List<String> workingDays,
    required String startTime,
    required String endTime,
  }) async {
    await _firestore.collection('clinics').add({
      'doctorId': doctorId,
      'name': clinicName,
      'address': address,
      'workingDays': workingDays,
      'startTime': startTime,
      'endTime': endTime,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> todaysQueueStream(
    String doctorId,
  ) {
    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    return _firestore
        .collection('doctors')
        .doc(doctorId)
        .collection('appointments')
        .where(
          'scheduledAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart),
        )
        .where(
          'scheduledAt',
          isLessThan: Timestamp.fromDate(dayEnd),
        )
        .orderBy('scheduledAt')
        .snapshots();
  }

  Future<void> updateAppointmentStatus(
    String appointmentId,
    String status,
  ) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> patientsStream(
    String doctorId,
  ) {
    return _firestore
        .collection('doctors')
        .doc(doctorId)
        .collection('patients')
        .orderBy('patientName')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> pharmaciesStream() {
    return _firestore.collection('pharmacies').orderBy('name').snapshots();
  }

  Future<void> addPrescription({
    required String patientId,
    required String doctorId,
    required String diagnosis,
    required List<Map<String, dynamic>> medications,
    required String notes,
    String? appointmentId,
  }) async {
    final payload = {
      'doctorId': doctorId,
      'diagnosis': diagnosis,
      'notes': notes,
      'medications': medications,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('patients')
        .doc(patientId)
        .collection('prescriptions')
        .add(payload);

    if (appointmentId != null) {
      await _firestore.collection('appointments').doc(appointmentId).set(
        {'prescription': payload},
        SetOptions(merge: true),
      );
    }
  }

  Future<void> sendPrescriptionToPharmacy({
    required String pharmacyId,
    required String patientId,
    required String doctorId,
    required String message,
  }) async {
    await _firestore.collection('pharmacy_notifications').add({
      'pharmacyId': pharmacyId,
      'patientId': patientId,
      'doctorId': doctorId,
      'message': message,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> uploadLicenseFile({
    required File file,
    required String doctorId,
  }) async {
    final fileName =
        '${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}_${file.uri.pathSegments.isNotEmpty ? file.uri.pathSegments.last : 'license'}';
    final ref = _storage
        .ref()
        .child('licenses')
        .child(doctorId)
        .child(fileName);

    await ref.putFile(file);
    final downloadUrl = await ref.getDownloadURL();

    await _firestore.collection('licenses').doc(doctorId).set({
      'status': 'pending',
      'updatedAt': FieldValue.serverTimestamp(),
      'files': FieldValue.arrayUnion([downloadUrl]),
    }, SetOptions(merge: true));

    return downloadUrl;
  }

  Future<List<Map<String, dynamic>>> fetchPatientsForDropdown(
    String doctorId,
  ) async {
    final snapshot = await _firestore
        .collection('doctors')
        .doc(doctorId)
        .collection('patients')
        .orderBy('patientName')
        .get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  Future<List<Map<String, dynamic>>> fetchPharmaciesForDropdown() async {
    final snapshot =
        await _firestore.collection('pharmacies').orderBy('name').get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }

  /// Fetch all clinics for a specific doctor (used by patients for booking)
  Future<List<Map<String, dynamic>>> fetchClinicsForDoctor(
    String doctorId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('clinics')
          .where('doctorId', isEqualTo: doctorId)
          .get()
          .timeout(const Duration(seconds: 10));

      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Stream of clinics for a doctor (real-time updates)
  Stream<QuerySnapshot<Map<String, dynamic>>> clinicsForDoctorStream(
    String doctorId,
  ) {
    return _firestore
        .collection('clinics')
        .where('doctorId', isEqualTo: doctorId)
        .snapshots();
  }

  Future<int> clinicsCount(String doctorId) async {
    final snapshot = await _firestore
        .collection('clinics')
        .where('doctorId', isEqualTo: doctorId)
        .get();
    return snapshot.size;
  }

  Future<int> patientsCount(String doctorId) async {
    final snapshot = await _firestore
        .collection('doctors')
        .doc(doctorId)
        .collection('patients')
        .get();
    return snapshot.size;
  }
}

