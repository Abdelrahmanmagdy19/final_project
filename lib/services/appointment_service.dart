import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cure_link/models/model/booking_data.dart';
import 'package:cure_link/models/model/doctors_details_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> _getUserData(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc.data();
    }
    return null;
  }

  Future<void> bookAppointment({
    required DoctorsDetailsModel doctor,
    required BookingData booking,
    required String reason,
    required double total,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null || currentUser.email == null) {
      throw Exception('User not logged in');
    }

    final userData = await _getUserData(currentUser.uid);
    final String patientName = userData?['name'] ?? 'Patient Name N/A';
    final String patientImage =
        userData?['imageUrl'] ??
        'https://img.freepik.com/premium-vector/gray-picture-person-with-gray-background_1197690-22.jpg?semt=ais_hybrid&w=740&q=80';

    final appointmentData = {
      'doctorName': doctor.name ?? 'N/A',
      'doctorSpecialization': doctor.specialty ?? 'N/A',
      'doctorImage': doctor.image ?? '',
      'doctorUid': doctor.uid ?? 'N/A',
      'userName': patientName,
      'userImage': patientImage,
      'userUid': currentUser.uid,
      'userEmail': currentUser.email,
      'appointmentDate': booking.selectedDate ?? 'N/A',
      'appointmentTime': booking.selectedTime ?? 'N/A',
      'reason': reason,
      'consultationPrice': doctor.price?.toString() ?? '0.0',
      'adminFee': 15.0,
      'totalPrice': total.toStringAsFixed(2),
      'status': 'Confirmed',
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('Schedule').add(appointmentData);
  }
}
