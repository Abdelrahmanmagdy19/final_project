import 'package:cure_link/models/hospital_model.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // 🎯 تم استيراد المكتبة

class HospitalsDetailsScreen extends StatelessWidget {
  final HospitalModel hospital;

  const HospitalsDetailsScreen({super.key, required this.hospital});

  // 🎯 دالة لفتح الخريطة باستخدام الاسم والعنوان معًا
  Future<void> _launchMap(String query) async {
    // بناء رابط بحث عالمي للخريطة (Google Maps URL scheme)
    final String url =
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}';

    final uri = Uri.parse(url);

    // محاولة تشغيل التطبيق الخارجي (الخريطة)
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  // دالة مساعدة لإنشاء صف تفاصيل عصري
  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String title,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.greenColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: AppColor.greenColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: valueColor ?? Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hospital Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          String combinedQuery =
              "${hospital.name}, ${hospital.locationAddress}";
          _launchMap(combinedQuery);
        },
        icon: const Icon(Icons.directions),
        label: const Text('Get Route'),
        backgroundColor: AppColor.greenColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Image.network(
                hospital.imagePath,
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hospital.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hospital.specialty,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColor.greenColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildDetailRow(
                    context,
                    Icons.location_on_outlined,
                    'Address',
                    hospital.locationAddress,
                  ),
                  _buildDetailRow(
                    context,
                    hospital.is24Hours
                        ? Icons.watch_later_outlined
                        : Icons.access_time_filled,
                    'Hours',
                    hospital.is24Hours ? 'Open 24 Hours' : hospital.openingTime,
                    valueColor: hospital.is24Hours
                        ? AppColor.greenColor
                        : AppColor.darkGreyColor,
                  ),
                  _buildDetailRow(
                    context,
                    Icons.phone_outlined,
                    'Contact',
                    hospital.phoneNumber,
                  ),

                  const SizedBox(height: 24),

                  Divider(color: Colors.grey[300]),

                  const SizedBox(height: 16),

                  // Description/About
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hospital.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
