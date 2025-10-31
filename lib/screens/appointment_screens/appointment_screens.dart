import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cure_link/widgets/custom_show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cure_link/models/model/booking_data.dart';
import 'package:cure_link/models/model/doctors_details_model.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/widgets/custom_bottom.dart';
import 'package:cure_link/widgets/custom_divider.dart';
import 'package:cure_link/widgets/custom_icon_container.dart';
import 'package:cure_link/widgets/custom_payment_details_row.dart';
import 'package:cure_link/widgets/custom_top_doctor_page_container.dart';
import 'package:flutter/material.dart';

class AppointmentScreens extends StatelessWidget {
  final DoctorsDetailsModel doctor;
  final BookingData bookingDetails;

  const AppointmentScreens({
    super.key,
    required this.doctor,
    required this.bookingDetails,
  });

  Future<void> _bookAppointment(
    BuildContext context,
    String painText,
    double total,
  ) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null || currentUser.email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                Text(
                  'User not logged in. Please log in to book an appointment.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!context.mounted) return;

      final String patientName = userDoc.exists
          ? (userDoc.data()?['name'] ?? 'Patient Name N/A')
          : 'Patient Name N/A';
      final String patientImage = userDoc.exists
          ? (userDoc.data()?['imageUrl'] ?? 'https://via.placeholder.com/150')
          : 'https://via.placeholder.com/150';

      final appointmentData = {
        'doctorName': doctor.name ?? 'N/A',
        'doctorSpecialization': doctor.specialty ?? 'N/A',
        'doctorImage': doctor.image ?? '',
        'doctorUid': doctor.uid ?? 'N/A',
        'userName': patientName,
        'userImage': patientImage,
        'userUid': currentUser.uid,
        'userEmail': currentUser.email,
        'appointmentDate': bookingDetails.selectedDate ?? 'N/A',
        'appointmentTime': bookingDetails.selectedTime ?? 'N/A',
        'reason': painText,
        'consultationPrice': doctor.price?.toString() ?? '0.0',
        'adminFee': 15.0,
        'totalPrice': total.toStringAsFixed(2),
        'status': 'Confirmed',
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('Schedule')
          .add(appointmentData);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),

              Text(
                'Appointment booked successfully!',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      CustomShowSnackBar(
        context: context,
        message: 'Failed to book appointment. Check connection.',
        seconds: 2,
        backgroundColor: Colors.red,
        iconData: Icons.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String painText =
        (bookingDetails.pain == null || bookingDetails.pain!.isEmpty)
        ? 'You have to tell your pain'
        : bookingDetails.pain!;
    final double doctorPrice =
        double.tryParse(doctor.price?.toString() ?? '0.0') ?? 0.0;
    const double adminFee = 15;
    final double total = doctorPrice + adminFee;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Appointment Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTopDoctorPageContainer(doctor: doctor, onTap: () {}),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Date',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Change',
                    style: TextStyle(color: AppColor.darkGreyColor),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  CustomIconContainer(
                    iconData: Icons.date_range,
                    borderRadius: 50,
                    padding: 5,
                  ),
                  const SizedBox(width: 25.5),
                  Text(
                    "${bookingDetails.selectedDate ?? ''} | ${bookingDetails.selectedTime ?? ''}",
                    style: const TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: CustomDivider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reason',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Change',
                    style: TextStyle(color: AppColor.darkGreyColor),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  CustomIconContainer(
                    iconData: Icons.edit_document,
                    borderRadius: 50,
                    padding: 5,
                  ),
                  const SizedBox(width: 25.5),
                  Expanded(
                    child: Text(
                      painText,
                      style: const TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: CustomDivider(),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Payment Detail',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              CustomPaymentDetailsRow(
                price: "\$${doctor.price}",
                text: 'Consultation',
              ),
              CustomPaymentDetailsRow(price: '\$$adminFee', text: 'Admin Fee'),
              const CustomPaymentDetailsRow(
                price: '_',
                text: 'Aditional Discount',
              ),
              CustomPaymentDetailsRow(
                price: '\$${(total).toStringAsFixed(2)}',
                text: 'Total',
                color: AppColor.greenColor,
              ),
              const SizedBox(height: 10),
              CustomButton(
                text: 'Booking',
                buttonWidth: 192,
                buttonHeight: 54,
                onTap: () => _bookAppointment(context, painText, total),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
