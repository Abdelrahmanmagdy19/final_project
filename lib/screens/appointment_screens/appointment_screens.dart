import 'package:flutter/material.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/widgets/custom_bottom.dart';
import 'package:cure_link/widgets/custom_divider.dart';
import 'package:cure_link/widgets/custom_icon_container.dart';
import 'package:cure_link/widgets/custom_payment_details_row.dart';
import 'package:cure_link/widgets/custom_top_doctor_page_container.dart';
import 'package:cure_link/widgets/custom_show_snack_bar.dart';
import 'package:cure_link/models/booking_data.dart';
import 'package:cure_link/models/doctors_details_model.dart';
import 'package:cure_link/services/appointment_service.dart';

class AppointmentScreen extends StatelessWidget {
  final DoctorsDetailsModel doctor;
  final BookingData bookingDetails;

  const AppointmentScreen({
    super.key,
    required this.doctor,
    required this.bookingDetails,
  });

  Future<void> _handleBooking(
    BuildContext context,
    String reason,
    double total,
  ) async {
    final appointmentService = AppointmentService();

    try {
      await appointmentService.bookAppointment(
        doctor: doctor,
        booking: bookingDetails,
        reason: reason,
        total: total,
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
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

      if (e.toString().contains('User not logged in')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'User not logged in. Please log in to book an appointment.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        CustomShowSnackBar(
          context: context,
          message: 'Failed to book appointment. Check connection.',
          seconds: 2,
          backgroundColor: Colors.red,
          iconData: Icons.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String reason =
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
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTopDoctorPageContainer(doctor: doctor, onTap: () {}),
              const SizedBox(height: 10),
              _buildSection(
                title: 'Date',
                icon: Icons.date_range,
                text:
                    "${bookingDetails.selectedDate ?? ''} | ${bookingDetails.selectedTime ?? ''}",
              ),
              const CustomDivider(),
              _buildSection(
                title: 'Reason',
                icon: Icons.edit_document,
                text: reason,
              ),
              const CustomDivider(),
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
                text: 'Additional Discount',
              ),
              CustomPaymentDetailsRow(
                price: '\$${total.toStringAsFixed(2)}',
                text: 'Total',
                color: AppColor.greenColor,
              ),
              const SizedBox(height: 10),
              CustomButton(
                text: 'Booking',
                buttonWidth: 192,
                buttonHeight: 54,
                onTap: () => _handleBooking(context, reason, total),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required String text,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Change',
              style: TextStyle(color: AppColor.darkGreyColor),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            CustomIconContainer(iconData: icon, borderRadius: 50, padding: 5),
            const SizedBox(width: 25.5),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF555555),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
