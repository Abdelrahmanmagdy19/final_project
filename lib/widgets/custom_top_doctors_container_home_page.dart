import 'package:cure_link/models/model/doctors_details_model.dart';
import 'package:cure_link/screens/doctor_details_screen/doctor_details_screen.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:flutter/material.dart';

class CustomTopDoctorsContainerHomePage extends StatelessWidget {
  const CustomTopDoctorsContainerHomePage({super.key, this.topDoctorsModel});
  final DoctorsDetailsModel? topDoctorsModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailsScreen(doctor: topDoctorsModel!),
          ),
        );
      },
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Column(
            children: [
              SizedBox(height: 4),
              topDoctorsModel?.image != null
                  ? CircleAvatar(
                      radius: 35.5,
                      backgroundImage: NetworkImage(topDoctorsModel!.image!),
                    )
                  : CircleAvatar(
                      radius: 35.5,
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(Icons.person, size: 40, color: Colors.grey),
                    ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  topDoctorsModel?.name ?? 'No name',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 3),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  topDoctorsModel?.specialty ?? 'No specialty',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.lightGreenColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, size: 12, color: AppColor.greenColor),
                        SizedBox(width: 2),
                        Text(
                          '${topDoctorsModel?.totalRating ?? 0}',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColor.greenColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'ex: ${topDoctorsModel?.experience} years',

                    style: TextStyle(fontSize: 10, color: Colors.grey),
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
