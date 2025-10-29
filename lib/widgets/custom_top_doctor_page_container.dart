import 'package:cure_link/models/model/doctors_details_model.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:flutter/material.dart';

class CustomTopDoctorPageContainer extends StatelessWidget {
  const CustomTopDoctorPageContainer({
    super.key,
    required this.doctor,
    required this.onTap,
  });
  final DoctorsDetailsModel doctor;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          height: 125,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                height: 111,
                width: 111,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      doctor.image ??
                          'https://via.placeholder.com/150', // رابط صورة افتراضية
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialty ?? 'No Specialty',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.darkGreyColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 18,
                    width: 41,
                    decoration: BoxDecoration(
                      color: AppColor.lightGreenColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, size: 12, color: AppColor.greenColor),
                        const SizedBox(width: 2),
                        Text(
                          doctor.totalRating?.toStringAsFixed(1) ?? '0.0',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColor.greenColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${doctor.experience?.round() ?? 0} years experience',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
