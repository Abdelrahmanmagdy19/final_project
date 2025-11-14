import 'package:cure_link/models/cubits/top_doctor_cubit/top_doctor_cubit.dart';
import 'package:cure_link/screens/health_article_screen/health_arricle_screen.dart';
import 'package:cure_link/screens/top_doctor_screen/top_doctor_screen.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/utils/app_images.dart';
import 'package:cure_link/widgets/custom_list_view_health_article.dart';
import 'package:cure_link/widgets/custom_list_view_top_doctor_home_page.dart';
import 'package:cure_link/widgets/custom_row_container_search.dart';
import 'package:cure_link/widgets/custom_row_see_all_home_screen.dart';
import 'package:cure_link/widgets/custom_text_from_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Find your desire',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Icon(Icons.notifications_none, color: AppColor.greenColor),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'health solution',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: CustomTextFormField(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  onSaved: (p0) {},
                ),
              ),
              SizedBox(height: 12),
              CustomRowContainerSearch(),
              SizedBox(height: 14),
              Image.asset(AppImages.ctaImage),
              CustomRowSeeAllHomeScreen(
                onSeeAllTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) =>
                            TopDoctorCubit()..fetchTopDoctors(),
                        child: const TopDoctorScreen(),
                      ),
                    ),
                  );
                },
                title: 'Top Doctors',
              ),
              CustomListViewTopDoctorHomePage(),
              CustomRowSeeAllHomeScreen(
                title: 'Health Article',
                onSeeAllTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return HealthArticleScreen();
                      },
                    ),
                  );
                },
              ),
              //Health article section
              CustomListViewHealthArticle(),
            ],
          ),
        ),
      ),
    );
  }
}
