import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cure_link/features/doctor/services/doctor_repository.dart';
import 'package:cure_link/features/patient/models/booking_data.dart';
import 'package:cure_link/shared/models/doctors_details_model.dart';
import 'package:cure_link/shared/services/appointment_service.dart';
import 'package:cure_link/shared/services/chat_link_service.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/widgets/custom_bottom.dart';
import 'package:cure_link/widgets/custom_divider.dart';
import 'package:cure_link/widgets/custom_icon_container.dart';
import 'package:cure_link/widgets/custom_payment_details_row.dart';
import 'package:cure_link/widgets/custom_show_snack_bar.dart';
import 'package:cure_link/widgets/custom_top_doctor_page_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppointmentScreens extends StatefulWidget {
  final DoctorsDetailsModel doctor;
  final BookingData bookingDetails;

  const AppointmentScreens({
    super.key,
    required this.doctor,
    required this.bookingDetails,
  });

  @override
  State<AppointmentScreens> createState() => _AppointmentScreensState();
}

class _AppointmentScreensState extends State<AppointmentScreens> {
  final AppointmentService _appointmentService = AppointmentService();
  final ChatLinkService _chatLinkService = ChatLinkService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DoctorRepository _doctorRepository = DoctorRepository();
  bool _isBooking = false;
  List<Map<String, dynamic>> _clinics = [];
  Map<String, dynamic>? _selectedClinic;
  bool _isLoadingClinics = false;

  String get _painText {
    final pain = widget.bookingDetails.pain;
    return (pain == null || pain.isEmpty)
        ? 'You have to tell your pain'
        : pain;
  }

  double get _doctorPrice =>
      double.tryParse(widget.doctor.price?.toString() ?? '') ?? 0.0;

  @override
  void initState() {
    super.initState();
    _loadClinics();
  }

  Future<void> _loadClinics() async {
    if (widget.doctor.uid == null) return;

    setState(() => _isLoadingClinics = true);
    try {
      final clinics = await _doctorRepository.fetchClinicsForDoctor(
        widget.doctor.uid!,
      );
      if (mounted) {
        setState(() {
          _clinics = clinics;
          _isLoadingClinics = false;
          // Auto-select first clinic if available
          if (clinics.isNotEmpty && _selectedClinic == null) {
            _selectedClinic = clinics.first;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingClinics = false);
      }
    }
  }

  Future<void> _handleBooking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to complete booking'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (widget.doctor.uid == null ||
        widget.bookingDetails.selectedDate == null ||
        widget.bookingDetails.selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Missing appointment details'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_clinics.isNotEmpty && _selectedClinic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a clinic before booking'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _isBooking = true);
    try {
      final patientDoc =
          await _firestore.collection('users').doc(user.uid).get();
      final patientData = patientDoc.data() ?? {};
      final patientName =
          patientData['name'] ?? user.displayName ?? 'Unknown Patient';
      final patientImage = patientData['imageUrl'] ?? '';
      final patientEmail = patientData['email'] ?? user.email ?? '';

      final scheduledAt = _appointmentService.buildScheduledDateTime(
        dateLabel: widget.bookingDetails.selectedDate!,
        timeLabel: widget.bookingDetails.selectedTime!,
      );

      await _appointmentService.createAppointment(
        doctorId: widget.doctor.uid!,
        doctorName: widget.doctor.name ?? 'Doctor',
        doctorImage: widget.doctor.image ?? '',
        doctorEmail: widget.doctor.email ?? '',
        patientId: user.uid,
        patientName: patientName,
        patientImage: patientImage,
        patientEmail: patientEmail,
        painDescription: _painText,
        price: _doctorPrice,
        scheduledDateTime: scheduledAt,
        clinicId: _selectedClinic?['id'],
        clinicName: _selectedClinic?['name'],
      );

      await _chatLinkService.ensureChatLink(
        patientId: user.uid,
        patientName: patientName,
        patientEmail: patientEmail,
        patientImage: patientImage,
        doctorId: widget.doctor.uid!,
        doctorName: widget.doctor.name ?? 'Doctor',
        doctorEmail: widget.doctor.email ?? '',
        doctorImage: widget.doctor.image ?? '',
      );

      if (!mounted) return;
      CustomShowSnackBar(
        context: context,
        message: 'Appointment booked successfully',
        seconds: 2,
      ).build(context);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to book appointment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isBooking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const double adminFee = 15;
    final double total = _doctorPrice + adminFee;

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
              CustomTopDoctorPageContainer(doctor: widget.doctor, onTap: () {}),
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
                  const CustomIconContainer(
                    iconData: Icons.date_range,
                    borderRadius: 50,
                    padding: 5,
                  ),
                  const SizedBox(width: 25.5),
                  Text(
                    "${widget.bookingDetails.selectedDate ?? ''} | ${widget.bookingDetails.selectedTime ?? ''}",
                    style: const TextStyle(
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
                  const CustomIconContainer(
                    iconData: Icons.edit_document,
                    borderRadius: 50,
                    padding: 5,
                  ),
                  const SizedBox(width: 25.5),
                  Expanded(
                    child: Text(
                      _painText,
                      style: const TextStyle(
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
              // Clinic Selection
              if (_clinics.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Clinic',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Change',
                      style: TextStyle(color: AppColor.darkGreyColor),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _isLoadingClinics
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<Map<String, dynamic>>(
                        value: _selectedClinic,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        items: _clinics.map((clinic) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: clinic,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  clinic['name'] ?? 'Unnamed Clinic',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (clinic['address'] != null)
                                  Text(
                                    clinic['address'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (clinic) {
                          setState(() {
                            _selectedClinic = clinic;
                          });
                        },
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: CustomDivider(),
                ),
              ],
              if (_clinics.isEmpty && !_isLoadingClinics)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange[400]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This doctor has not added clinics yet. Booking will be saved without a clinic selection.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Payment Detail',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              CustomPaymentDetailsRow(
                price: "\$${widget.doctor.price}",
                text: 'Consultation',
              ),
              const CustomPaymentDetailsRow(
                  price: '$adminFee', text: 'Admin Fee'),
              const CustomPaymentDetailsRow(
                  price: '_', text: 'Aditional Discount'),
              CustomPaymentDetailsRow(
                price: '\$${(total).toStringAsFixed(2)}',
                text: 'Total',
                color: AppColor.greenColor,
              ),
              const SizedBox(height: 10),
              CustomButton(
                text: _isBooking ? 'Booking...' : 'Booking',
                buttonWidth: 192,
                buttonHeight: 54,
                onTap: _isBooking ? null : _handleBooking,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

