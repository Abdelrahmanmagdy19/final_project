import 'package:cure_link/models/medicine_model.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/widgets/custom_medicine_container.dart';
import 'package:cure_link/widgets/custom_row_see_all_home_screen.dart';
import 'package:cure_link/widgets/custom_text_from_field.dart';
import 'package:flutter/material.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  List<MedicineModel> foundMedications = [];

  bool _isSearching = false;

  @override
  void initState() {
    foundMedications = allMedications;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<MedicineModel> results = [];

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
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
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
