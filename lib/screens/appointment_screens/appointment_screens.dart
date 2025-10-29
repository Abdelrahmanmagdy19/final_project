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

  @override
  Widget build(BuildContext context) {
    final String painText =
        (bookingDetails.pain == null || bookingDetails.pain!.isEmpty)
        ? 'You have to tell your pain'
        : bookingDetails.pain!;
    final double doctorPrice =
        double.tryParse(doctor.price?.toString() ?? '') ?? 0.0;
    final double adminFee = 15;
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
                  Text(
                    'Date',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Change',
                    style: TextStyle(color: AppColor.darkGreyColor),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  CustomIconContainer(
                    iconData: Icons.date_range,
                    borderRadius: 50,
                    padding: 5,
                  ),
                  SizedBox(width: 25.5),
                  Text(
                    "${bookingDetails.selectedDate ?? ''} | ${bookingDetails.selectedTime ?? ''}",
                    style: TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: CustomDivider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reson',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Change',
                    style: TextStyle(color: AppColor.darkGreyColor),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  CustomIconContainer(
                    iconData: Icons.edit_document,
                    borderRadius: 50,
                    padding: 5,
                  ),
                  SizedBox(width: 25.5),
                  Expanded(
                    child: Text(
                      painText,
                      style: TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: CustomDivider(),
              ),
              Align(
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
              CustomPaymentDetailsRow(price: '$adminFee', text: 'Admin Fee'),
              CustomPaymentDetailsRow(price: '_', text: 'Aditional Discount'),
              CustomPaymentDetailsRow(
                price: '\$${(total).toStringAsFixed(2)}',
                text: 'Total',
                color: AppColor.greenColor,
              ),
              SizedBox(height: 10),
              CustomButton(
                text: 'Booking',
                buttonWidth: 192,
                buttonHeight: 54,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
