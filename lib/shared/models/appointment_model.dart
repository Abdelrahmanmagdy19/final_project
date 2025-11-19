import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorImage;
  final String patientId;
  final String patientName;
  final String patientImage;
  final String patientEmail;
  final String painDescription;
  final double price;
  final String status;
  final Timestamp scheduledAt;
  final Timestamp createdAt;

  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorImage,
    required this.patientId,
    required this.patientName,
    required this.patientImage,
    required this.patientEmail,
    required this.painDescription,
    required this.price,
    required this.status,
    required this.scheduledAt,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': id,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorImage': doctorImage,
      'patientId': patientId,
      'patientName': patientName,
      'patientImage': patientImage,
      'patientEmail': patientEmail,
      'painDescription': painDescription,
      'price': price,
      'status': status,
      'scheduledAt': scheduledAt,
      'createdAt': createdAt,
    };
  }

  factory AppointmentModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return AppointmentModel(
      id: doc.id,
      doctorId: data['doctorId'] ?? '',
      doctorName: data['doctorName'] ?? '',
      doctorImage: data['doctorImage'] ?? '',
      patientId: data['patientId'] ?? '',
      patientName: data['patientName'] ?? '',
      patientImage: data['patientImage'] ?? '',
      patientEmail: data['patientEmail'] ?? '',
      painDescription: data['painDescription'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      status: data['status'] ?? 'pending',
      scheduledAt: data['scheduledAt'] as Timestamp? ?? Timestamp.now(),
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
    );
  }
}

