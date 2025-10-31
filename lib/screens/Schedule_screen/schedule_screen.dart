import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/widgets/custom_bottom.dart';
import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Schedule Screen',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.schedule, color: AppColor.greenColor, size: 28),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 16),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColor.greyColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Doctor Name',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Specialization',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColor.lightGreyColor,
                              ),
                            ),
                          ],
                        ),
                        Spacer(flex: 1),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww&fm=jpg&q=60&w=3000',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Appointment Date & Time'),
                        Text('Status: Confirmed'),
                      ],
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          text: 'Cancel',
                          buttonWidth: 145,
                          buttonHeight: 46,
                          buttonColor: AppColor.lightGreenColor,
                          borderRadius: BorderRadius.circular(8),
                          textColor: AppColor.lightGreyColor,
                          onTap: () {},
                        ),
                        CustomButton(
                          text: 'Reschedule',
                          buttonWidth: 145,
                          buttonHeight: 46,
                          buttonColor: AppColor.greenColor,
                          borderRadius: BorderRadius.circular(8),
                          textColor: Colors.white,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
