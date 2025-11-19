import 'dart:io';

import 'package:cure_link/features/doctor/services/doctor_repository.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DoctorPrescriptionsScreen extends StatefulWidget {
  const DoctorPrescriptionsScreen({super.key});

  @override
  State<DoctorPrescriptionsScreen> createState() =>
      _DoctorPrescriptionsScreenState();
}

class _DoctorPrescriptionsScreenState
    extends State<DoctorPrescriptionsScreen> {
  final DoctorRepository _repository = DoctorRepository();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final List<_MedicationField> _medications = [
    _MedicationField(),
  ];

  bool _isSubmitting = false;
  bool _isUploadingLicense = false;
  String? _selectedPatientId;
  String? _selectedPharmacyId;
  List<Map<String, dynamic>> _patients = [];
  List<Map<String, dynamic>> _pharmacies = [];
  String? _licenseUploadedMessage;

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    final doctorId = FirebaseAuth.instance.currentUser?.uid;
    if (doctorId == null) return;
    final patients = await _repository.fetchPatientsForDropdown(doctorId);
    final pharmacies = await _repository.fetchPharmaciesForDropdown();
    if (mounted) {
      setState(() {
        _patients = patients;
        _pharmacies = pharmacies;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final doctorId = FirebaseAuth.instance.currentUser?.uid;
    if (doctorId == null || _selectedPatientId == null) return;

    setState(() => _isSubmitting = true);
    final medicationsPayload = _medications
        .map((med) => {
              'name': med.nameController.text.trim(),
              'dosage': med.dosageController.text.trim(),
              'duration': med.durationController.text.trim(),
              'notes': med.notesController.text.trim(),
            })
        .toList();

    try {
      await _repository.addPrescription(
        patientId: _selectedPatientId!,
        doctorId: doctorId,
        diagnosis: _diagnosisController.text.trim(),
        medications: medicationsPayload,
        notes: _notesController.text.trim(),
      );

      if (_selectedPharmacyId != null) {
        await _repository.sendPrescriptionToPharmacy(
          pharmacyId: _selectedPharmacyId!,
          patientId: _selectedPatientId!,
          doctorId: doctorId,
          message:
              'New prescription for patient $_selectedPatientId from doctor $doctorId',
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColor.greenColor,
            content: const Text(
              'Prescription saved successfully',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to save prescription: $e'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _handleLicenseUpload() async {
    final doctorId = FirebaseAuth.instance.currentUser?.uid;
    if (doctorId == null) return;
    final picker = ImagePicker();
    final XFile? rawFile = await picker.pickImage(source: ImageSource.gallery);
    if (rawFile == null) return;

    setState(() => _isUploadingLicense = true);
    try {
      final file = File(rawFile.path);
      await _repository.uploadLicenseFile(file: file, doctorId: doctorId);
      if (mounted) {
        setState(() {
          _licenseUploadedMessage = 'License uploaded for review.';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Upload failed: $e'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingLicense = false);
    }
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _notesController.dispose();
    for (final med in _medications) {
      med.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Prescriptions & Licenses'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPrescriptionForm(),
              const SizedBox(height: 24),
              _buildLicenseCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrescriptionForm() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Electronic Prescription',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPatientId,
              items: _patients
                  .map(
                    (patient) => DropdownMenuItem(
                      value: patient['id'] as String,
                      child: Text(patient['name'] ?? 'Patient'),
                    ),
                  )
                  .toList(),
              decoration: const InputDecoration(labelText: 'Select Patient'),
              onChanged: (value) {
                setState(() => _selectedPatientId = value);
              },
              validator: (value) =>
                  value == null ? 'Please select a patient' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _diagnosisController,
              decoration: const InputDecoration(labelText: 'Diagnosis'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            ..._medications.map(
              (med) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _MedicationFields(
                  field: med,
                  onRemove: _medications.length > 1
                      ? () {
                          setState(() => _medications.remove(med));
                        }
                      : null,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  setState(() => _medications.add(_MedicationField()));
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Medication'),
              ),
            ),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedPharmacyId,
              items: _pharmacies
                  .map(
                    (pharmacy) => DropdownMenuItem(
                      value: pharmacy['id'] as String,
                      child: Text(pharmacy['name'] ?? 'Pharmacy'),
                    ),
                  )
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'Send to Pharmacy (optional)',
              ),
              onChanged: (value) {
                setState(() => _selectedPharmacyId = value);
              },
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
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _isSubmitting ? null : _handleSubmit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Send Prescription'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLicenseCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Licenses & Certificates',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload your official documents for admin verification.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isUploadingLicense ? null : _handleLicenseUpload,
              icon: _isUploadingLicense
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_file),
              label: Text(
                _isUploadingLicense ? 'Uploading...' : 'Upload License',
              ),
            ),
          ),
          if (_licenseUploadedMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _licenseUploadedMessage!,
              style: TextStyle(
                color: AppColor.greenColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MedicationField {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  void dispose() {
    nameController.dispose();
    dosageController.dispose();
    durationController.dispose();
    notesController.dispose();
  }
}

class _MedicationFields extends StatelessWidget {
  final _MedicationField field;
  final VoidCallback? onRemove;

  const _MedicationFields({required this.field, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: field.nameController,
                  decoration: const InputDecoration(labelText: 'Medication'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
              ),
              if (onRemove != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.close),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: field.dosageController,
                  decoration: const InputDecoration(labelText: 'Dosage'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: field.durationController,
                  decoration: const InputDecoration(labelText: 'Duration'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: field.notesController,
            decoration: const InputDecoration(labelText: 'Instructions'),
          ),
        ],
      ),
    );
  }
}

