import 'package:cure_link/features/doctor/services/doctor_repository.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoctorOverviewScreen extends StatefulWidget {
  const DoctorOverviewScreen({super.key});

  @override
  State<DoctorOverviewScreen> createState() => _DoctorOverviewScreenState();
}

class _DoctorOverviewScreenState extends State<DoctorOverviewScreen> {
  final DoctorRepository _repository = DoctorRepository();
  DoctorDashboardSummary _summary = const DoctorDashboardSummary.empty();
  bool _loadingSummary = true;
  int _totalPatients = 0;
  int _totalClinics = 0;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    final doctorId = FirebaseAuth.instance.currentUser?.uid;
    if (doctorId == null) {
      if (mounted) {
        setState(() => _loadingSummary = false);
      }
      return;
    }
    
    if (mounted) {
      setState(() => _loadingSummary = true);
    }
    
    try {
      final results = await Future.wait([
        _repository.fetchDashboardSummary(doctorId),
        _repository.patientsCount(doctorId),
        _repository.clinicsCount(doctorId),
      ]);
      final summary = results[0] as DoctorDashboardSummary;
      final patientsCount = results[1] as int;
      final clinicsCount = results[2] as int;
      if (mounted) {
        setState(() {
          _summary = summary;
          _loadingSummary = false;
          _totalPatients = patientsCount;
          _totalClinics = clinicsCount;
        });
      }
    } catch (e) {
      // Ensure loading state is set to false even on error
      if (mounted) {
        setState(() {
          _loadingSummary = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorId = FirebaseAuth.instance.currentUser?.uid;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: doctorId == null
            ? _buildEmptyState(context)
            : RefreshIndicator(
                onRefresh: _loadSummary,
                child: StreamBuilder(
                  stream: _repository.doctorProfileStream(doctorId),
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
                                size: 48, color: Colors.red[300]),
                            const SizedBox(height: 12),
                            Text(
                              'Error loading profile: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                _loadSummary();
                                setState(() {});
                              },
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

                    final data =
                        snapshot.data?.data() ?? <String, dynamic>{};
                    final name = data['name'] ?? 'Doctor';
                    final specialization = data['specialization'] ?? '';

                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(name, specialization),
                          const SizedBox(height: 24),
                          _buildSummaryCards(),
                          const SizedBox(height: 24),
                          _buildQueuePreview(doctorId),
                          const SizedBox(height: 24),
                          _buildPatientInsights(),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_off_outlined,
                color: AppColor.greenColor, size: 48),
            const SizedBox(height: 12),
            const Text(
              'No authenticated doctor found.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String name, String specialization) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, $name 👋',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                specialization,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColor.greenColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(Icons.notifications_active_outlined,
              color: AppColor.greenColor),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    final cards = [
      _DashboardCardData(
        title: 'Today’s Visits',
        value: _loadingSummary
            ? '...'
            : _summary.todayAppointments.toString(),
        icon: Icons.calendar_today_outlined,
      ),
      _DashboardCardData(
        title: 'Revenue',
        value: _loadingSummary
            ? '...'
            : 'EGP ${_summary.todayRevenue.toStringAsFixed(2)}',
        icon: Icons.payments_outlined,
      ),
      _DashboardCardData(
        title: 'Rating',
        value:
            _loadingSummary ? '...' : _summary.averageRating.toStringAsFixed(1),
        icon: Icons.star_border_rounded,
      ),
    ];

    return Row(
      children: cards
          .map(
            (card) => Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: card == cards.last ? 0 : 12,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColor.greenColor.withValues(alpha: 0.12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(card.icon, color: AppColor.greenColor),
                    const SizedBox(height: 12),
                    Text(
                      card.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      card.title,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildQueuePreview(String doctorId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today’s Queue',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        StreamBuilder(
          stream: _repository.todaysQueueStream(doctorId),
          builder: (context, snapshot) {
            // Handle loading state
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            // Handle error state
            if (snapshot.hasError) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline,
                        size: 32, color: Colors.red[300]),
                    const SizedBox(height: 8),
                    Text(
                      'Error loading queue',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => setState(() {}),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // Handle empty state
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Text(
                  'No appointments scheduled for today.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              );
            }

            final docs = snapshot.data!.docs;

            return Container(
              decoration: _cardDecoration(),
              child: Column(
                children: docs.take(3).map((doc) {
                  final data = doc.data();
                  final patientName = data['patientName'] ?? 'Unknown';
                  final status = data['status'] ?? 'waiting';
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    title: Text(
                      patientName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('Status: $status'),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: AppColor.greenColor,
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPatientInsights() {
    final totalPatients = _totalPatients;
    final totalClinics = _totalClinics;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Insights',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Patients',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalPatients',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Clinics',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalClinics',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.grey[200]!),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

class _DashboardCardData {
  final String title;
  final String value;
  final IconData icon;

  _DashboardCardData({
    required this.title,
    required this.value,
    required this.icon,
  });
}

