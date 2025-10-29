import 'package:cure_link/models/model/booking_data.dart';
import 'package:cure_link/models/model/doctors_details_model.dart';
import 'package:cure_link/screens/appointment_screens/appointment_screens.dart';
import 'package:cure_link/widgets/custom_bottom.dart';
import 'package:cure_link/widgets/custom_divider.dart';
import 'package:cure_link/widgets/custom_hours_list_view.dart';
import 'package:cure_link/widgets/custom_icon_container.dart';
import 'package:cure_link/widgets/custom_list_view_separated_day.dart';
import 'package:cure_link/widgets/custom_text_from_field.dart';
import 'package:cure_link/widgets/custom_top_doctor_page_container.dart';
import 'package:flutter/material.dart';

class DoctorDetailsScreen extends StatefulWidget {
  const DoctorDetailsScreen({super.key, this.doctor});
  final DoctorsDetailsModel? doctor;

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  final TextEditingController painController = TextEditingController();

  BookingData _bookingData = BookingData();

  void _bookAppointment() {
    _bookingData = BookingData(
      selectedDate: _bookingData.selectedDate,
      selectedTime: _bookingData.selectedTime,
      pain: painController.text.trim(),
    );

    if (!_bookingData.isReadyToBook) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 15),
              Text(
                'Please select both a day and a time slot.',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentScreens(
          doctor: widget.doctor!,
          bookingDetails: _bookingData,
        ),
      ),
    );
  }

  @override
  void dispose() {
    painController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctor Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTopDoctorPageContainer(
                doctor: widget.doctor!,
                onTap: () {},
              ),
              const SizedBox(height: 5),
              const Text(
                'About Doctor',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                widget.doctor?.about ??
                    'No information available about this doctor.',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xff717784),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              CustomListViewSeparatedDay(
                onDaySelected: (dayString) {
                  setState(() {
                    _bookingData = BookingData(
                      selectedDate: dayString,
                      selectedTime: _bookingData.selectedTime,
                      pain: _bookingData.pain,
                    );
                  });
                },
              ),
              const SizedBox(height: 15),
              CustomDivider(),
              const SizedBox(height: 15),

              CustomHoursListView(
                onTimeSelected: (timeString) {
                  setState(() {
                    _bookingData = BookingData(
                      selectedDate: _bookingData.selectedDate,
                      selectedTime: timeString,
                      pain: _bookingData.pain,
                    );
                  });
                },
              ),
              CustomTextFormField(
                controller: painController,
                hintText: 'Pain',
                prefixIcon: const Icon(Icons.question_mark),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  CustomIconContainer(
                    iconData: Icons.chat_bubble_outline,
                    borderRadius: 15,
                    padding: 12,
                  ),
                  const SizedBox(width: 19),
                  CustomButton(
                    text: 'Book Apointment',
                    buttonWidth: 255,
                    buttonHeight: 54,
                    onTap: _bookAppointment,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
