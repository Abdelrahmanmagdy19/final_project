import 'package:cure_link/models/medicine_model.dart';
import 'package:cure_link/screens/medicine_details_screen/medicine_details_screen.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/widgets/custom_list_view_medicine.dart';
import 'package:cure_link/widgets/custom_row_see_all_home_screen.dart';
import 'package:cure_link/widgets/custom_text_from_field.dart';
import 'package:flutter/material.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MedicineModel> _filterMedications(List<MedicineModel> list) {
    if (_searchText.isEmpty) {
      return [];
    }
    final lowerCaseQuery = _searchText.toLowerCase();
    return list.where((medicine) {
      return medicine.name.toLowerCase().contains(lowerCaseQuery) ||
          medicine.mainUse.toLowerCase().contains(lowerCaseQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final allProducts = [...allMedications, ...allNonMedicationProducts];

    final filteredProducts = _filterMedications(allProducts);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pharmacy',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            CustomTextFormField(
              controller: _searchController,
              hintText: 'Search medications',
              suffixIcon: Icon(Icons.search, color: AppColor.greenColor),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
            const SizedBox(height: 10),

            Expanded(
              child: _searchText.isNotEmpty
                  ? _buildSearchResults(filteredProducts)
                  : _buildDefaultUI(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultUI() {
    return ListView(
      children: [
        Image.asset('assets/images/Screenshot 2025-11-20 190603.png'),
        CustomRowSeeAllHomeScreen(
          title: 'Popular Medications',
          onSeeAllTap: () {},
        ),
        CustomListViewMedicine(medicationList: allMedications),
        CustomRowSeeAllHomeScreen(title: 'Other Products', onSeeAllTap: () {}),
        CustomListViewMedicine(medicationList: allNonMedicationProducts),
      ],
    );
  }

  Widget _buildSearchResults(List<MedicineModel> results) {
    if (results.isEmpty) {
      return const Center(
        child: Text(
          'No matching products or medications found.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MedicineDetailsScreen(medicineModel: product),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.all(5),
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.lightGreyColor2),
            ),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(product.imagePathNote),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                SizedBox(
                  width: 227,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontFamily: 'inter',
                        ),
                      ),
                      Text(
                        product.mainUse,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'inter',

                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        product.quantityPcs,
                        style: TextStyle(
                          fontFamily: 'inter',
                          color: AppColor.darkGreyColor2,
                        ),
                      ),
                      Text(
                        product.priceNote,
                        style: TextStyle(
                          fontFamily: 'inter',
                          color: AppColor.greenColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
