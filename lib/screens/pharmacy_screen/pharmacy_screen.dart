import 'package:cure_link/models/medicine_model.dart';
import 'package:cure_link/screens/medicine_details_screen/medicine_details_screen.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/widgets/custom_row_see_all_home_screen.dart';
import 'package:cure_link/widgets/custom_text_from_field.dart';
import 'package:flutter/material.dart';

// ⭐️ تم تحويلها إلى StatefulWidget للتحكم في البحث
class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  // القائمة التي سيتم عرضها، والتي تتغير بناءً على مدخلات البحث
  List<MedicineModel> foundMedications = [];

  // المتغير لتتبع حالة البحث
  bool _isSearching = false;

  // تهيئة الحالة: نبدأ بعرض جميع الأدوية من allMedications
  @override
  void initState() {
    foundMedications =
        allMedications; // allMedications معرفة في medicine_model.dart
    super.initState();
  }

  // دالة البحث (الفلترة)
  void _runFilter(String enteredKeyword) {
    List<MedicineModel> results = [];

    // تحديث حالة _isSearching بناءً على ما إذا كان هناك نص مدخل
    setState(() {
      _isSearching = enteredKeyword.isNotEmpty;
    });

    if (enteredKeyword.isEmpty) {
      results = allMedications;
    } else {
      results = allMedications
          .where(
            (medicine) => medicine.name.toLowerCase().contains(
              enteredKeyword.toLowerCase(),
            ),
          )
          .toList();
    }

    // تحديث واجهة المستخدم بالنتائج الجديدة
    setState(() {
      foundMedications = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pharmacy',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextFormField(
                hintText: 'Search Medication',
                onChanged: (value) => _runFilter(value),
                suffixIcon: Icon(Icons.search, color: AppColor.greenColor),
              ),
              if (!_isSearching) ...[
                const SizedBox(height: 20),
                Image.asset('assets/images/Screenshot 2025-11-20 190603.png'),

                CustomRowSeeAllHomeScreen(
                  title: 'Popular Products',
                  onSeeAllTap: () {},
                ),
              ],
              if (_isSearching) const SizedBox(height: 20),

              _isSearching
                  ? CustomGridViewMedicine(medicationList: foundMedications)
                  : CustomListViewMedicine(medicationList: foundMedications),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomListViewMedicine extends StatelessWidget {
  final List<MedicineModel> medicationList;

  const CustomListViewMedicine({super.key, required this.medicationList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 165,
      child: medicationList.isNotEmpty
          ? ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return CustomMedicineContainer(
                  medicineModel: medicationList[index],
                );
              },
              scrollDirection: Axis.horizontal,
              itemCount: medicationList.length,
            )
          : const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Text(
                  'No matching medications found.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ),
    );
  }
}

class CustomGridViewMedicine extends StatelessWidget {
  final List<MedicineModel> medicationList;

  const CustomGridViewMedicine({super.key, required this.medicationList});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: medicationList.isNotEmpty
          ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 أعمدة في الصف
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7, // التحكم في نسبة الطول للعرض
              ),
              itemCount: medicationList.length,
              itemBuilder: (context, index) {
                return CustomMedicineContainer(
                  medicineModel: medicationList[index],
                  isGridView: true,
                );
              },
            )
          : const Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Text(
                'No search results found.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
    );
  }
}

class CustomMedicineContainer extends StatelessWidget {
  const CustomMedicineContainer({
    super.key,
    this.medicineModel,
    this.isGridView = false,
  });
  final MedicineModel? medicineModel;
  final bool isGridView;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const MedicineDetailsScreen();
            },
          ),
        );
      },
      child: Container(
        width: isGridView ? null : 118,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.lightGreyColor2),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 2, right: 8, bottom: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isGridView ? 8 : 18),

              Image.asset(
                medicineModel!.imagePathNote,
                width: double.infinity,
                height: 58,
                fit: BoxFit.cover,
              ),
              SizedBox(height: isGridView ? 8 : 18),
              Text(
                medicineModel!.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                medicineModel!.quantityPcs,
                style: TextStyle(fontSize: 10, color: AppColor.darkGreyColor2),
              ),
              isGridView ? const Spacer() : const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    medicineModel!.priceNote,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  // Add to cart icon
                  GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.add_circle, color: AppColor.greenColor),
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
