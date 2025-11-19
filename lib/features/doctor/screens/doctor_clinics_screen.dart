import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cure_link/features/doctor/services/doctor_repository.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoctorClinicsScreen extends StatefulWidget {
  const DoctorClinicsScreen({super.key});

  @override
  State<DoctorClinicsScreen> createState() => _DoctorClinicsScreenState();
}

class _DoctorClinicsScreenState extends State<DoctorClinicsScreen> {
  final DoctorRepository _repository = DoctorRepository();
  final List<String> _days = const [
    'Sat',
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
  ];

  @override
  Widget build(BuildContext context) {
    final doctorId = FirebaseAuth.instance.currentUser?.uid;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Clinics & Schedule'),
          centerTitle: true,
        ),
        body: doctorId == null
            ? _buildEmptyState()
            : StreamBuilder(
                stream: _repository.clinicsStream(doctorId),
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
                            'Error loading clinics',
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
                    return _buildNoClinics();
                  }
                  
                  final docs = [...snapshot.data!.docs];
                  docs.sort((a, b) {
                    final aTime = a.data()['createdAt'] as Timestamp?;
                    final bTime = b.data()['createdAt'] as Timestamp?;
                    final aMillis = aTime?.millisecondsSinceEpoch ?? 0;
                    final bMillis = bTime?.millisecondsSinceEpoch ?? 0;
                    return bMillis.compareTo(aMillis);
                  });
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data();
                      final workingDays =
                          List<String>.from(data['workingDays'] ?? []);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.grey[200]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name'] ?? 'Unnamed Clinic',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              data['address'] ?? 'No address',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: workingDays
                                  .map(
                                    (day) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColor.greenColor
                                            .withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        day,
                                        style: TextStyle(
                                          color: AppColor.greenColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _ScheduleChip(
                                  icon: Icons.schedule_outlined,
                                  label:
                                      '${data['startTime'] ?? '--:--'} - ${data['endTime'] ?? '--:--'}',
                                ),
                                const SizedBox(width: 12),
                                _ScheduleChip(
                                  icon: Icons.event_repeat_outlined,
                                  label: '${workingDays.length} days/week',
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddClinicSheet(context, doctorId),
          label: const Text('Add Clinic'),
          icon: const Icon(Icons.add),
          backgroundColor: AppColor.greenColor,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'Please login again to manage clinics.',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildNoClinics() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_hospital_outlined,
                size: 64, color: AppColor.greenColor),
            const SizedBox(height: 12),
            const Text(
              'No clinics added yet.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap the button below to add your first clinic and schedule.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddClinicSheet(
    BuildContext context,
    String? doctorId,
  ) async {
    if (doctorId == null) return;

    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final startTimeController = TextEditingController();
    final endTimeController = TextEditingController();
    final selectedDays = <String>{};
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, localSetState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 24,
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add Clinic',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Clinic Name',
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Working Days',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _days.map((day) {
                        final isSelected = selectedDays.contains(day);
                        return ChoiceChip(
                          label: Text(day),
                          selected: isSelected,
                          onSelected: (value) {
                            localSetState(() {
                              if (value) {
                                selectedDays.add(day);
                              } else {
                                selectedDays.remove(day);
                              }
                            });
                          },
                          selectedColor:
                              AppColor.greenColor.withValues(alpha: 0.15),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: startTimeController,
                            decoration: const InputDecoration(
                              labelText: 'Start Time (e.g., 09:00)',
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: endTimeController,
                            decoration: const InputDecoration(
                              labelText: 'End Time (e.g., 17:00)',
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.greenColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            await _repository.addClinic(
                              doctorId: doctorId,
                              clinicName: nameController.text.trim(),
                              address: addressController.text.trim(),
                              workingDays: selectedDays.toList(),
                              startTime: startTimeController.text.trim(),
                              endTime: endTimeController.text.trim(),
                            );
                            if (context.mounted) Navigator.pop(context);
                          }
                        },
                        child: const Text('Save Clinic'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

class _ScheduleChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ScheduleChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColor.greenColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

