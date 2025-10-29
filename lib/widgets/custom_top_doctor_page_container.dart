import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cure_link/models/model/doctors_details_model.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:flutter/material.dart';

class CustomTopDoctorPageContainer extends StatefulWidget {
  const CustomTopDoctorPageContainer({
    super.key,
    required this.doctor,
    required this.onTap,
  });
  final DoctorsDetailsModel doctor;
  final void Function()? onTap;

  @override
  State<CustomTopDoctorPageContainer> createState() =>
      _CustomTopDoctorPageContainerState();
}

class _CustomTopDoctorPageContainerState
    extends State<CustomTopDoctorPageContainer> {
  late double _currentRating;
  late double _initialRating;
  bool _isRatingIncreased = false;

  @override
  void initState() {
    super.initState();
    _initialRating = widget.doctor.totalRating ?? 0.0;
    _currentRating = _initialRating;
  }

  Future<void> _updateFirestoreRating(double newRating) async {
    String? doctorUid = widget.doctor.uid;

    if (doctorUid != null && doctorUid.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(doctorUid)
            .update({'totalRating': newRating});
        log(
          'Firestore updated successfully! New rating: $newRating',
          name: 'RatingUpdate',
        );
      } catch (e) {
        log(
          'Error updating Firestore for UID $doctorUid: $e',
          name: 'RatingUpdateError',
        );
        setState(() {
          _currentRating = _initialRating;
          _isRatingIncreased = false;
        });
      }
    } else {
      log(
        'Doctor UID is missing, cannot update Firestore.',
        name: 'RatingUpdateError',
      );
    }
  }

  void _toggleRating() {
    double ratingChange = _isRatingIncreased ? -1.0 : 1.0;
    double newRating = _currentRating + ratingChange;

    setState(() {
      _currentRating = newRating;
      _isRatingIncreased = !_isRatingIncreased;
    });

    _updateFirestoreRating(newRating);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
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
                      widget.doctor.image ?? 'https://via.placeholder.com/150',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.doctor.name ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.doctor.specialty ?? 'No Specialization',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.darkGreyColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: _toggleRating,
                    child: Container(
                      height: 18,
                      width: 41,
                      decoration: BoxDecoration(
                        color: AppColor.lightGreenColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            size: 12,
                            color: AppColor.greenColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _currentRating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.greenColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.doctor.experience?.round() ?? 0} years experience',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.doctor.email ?? 'No Email',
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
