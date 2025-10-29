import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/utils/app_icons.dart';
import 'package:cure_link/widgets/custom_container_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomRowContainerSearch extends StatelessWidget {
  const CustomRowContainerSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomContainerSearch(
          icons: SvgPicture.asset(AppIcons.doctor, fit: BoxFit.none),
          title: 'Doctor',
        ),
        SizedBox(width: 16),
        CustomContainerSearch(
          icons: Icon(
            Icons.medical_services_rounded,
            color: AppColor.greenColor,
          ),
          title: 'pharmacy',
        ),
        SizedBox(width: 16),
        CustomContainerSearch(
          icons: Icon(Icons.local_hospital, color: AppColor.greenColor),
          title: 'Hospital',
        ),
      ],
    );
  }
}
