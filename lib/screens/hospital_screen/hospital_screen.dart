import 'package:cure_link/models/hospital_model.dart';
import 'package:cure_link/screens/hospitals_details_screen/hospitals_details_screen.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/widgets/custom_text_from_field.dart';
import 'package:flutter/material.dart';

class HospitalScreen extends StatefulWidget {
  const HospitalScreen({super.key});

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  final ScrollController _controller = ScrollController();
  final List<HospitalModel> _allHospitals = HospitalModel.famousHospitals;

  // Pagination variables
  final int _pageSize = 5;
  int _currentMax = 5;
  bool _isLoadingMore = false;

  String _query = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize visible count
    _currentMax = _pageSize.clamp(0, _allHospitals.length);
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // --- Pagination Logic ---
  void _onScroll() {
    // Check if user is 200 pixels from the bottom AND not currently loading
    if (_controller.position.pixels >=
            _controller.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _currentMax < _filteredHospitals.length) {
      _loadMore();
    }
  }

  void _loadMore() async {
    setState(() => _isLoadingMore = true);
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    setState(() {
      // Increase _currentMax, clamped by the filtered list size
      _currentMax = (_currentMax + _pageSize).clamp(
        0,
        _filteredHospitals.length,
      );
      _isLoadingMore = false;
    });
  }
  // --- End Pagination Logic ---

  // --- Search Filter Logic ---
  List<HospitalModel> get _filteredHospitals {
    if (_query.isEmpty) return _allHospitals;
    final q = _query.toLowerCase();
    return _allHospitals
        .where(
          (h) =>
              h.name.toLowerCase().contains(q) ||
              h.locationAddress.toLowerCase().contains(q) ||
              h.specialty.toLowerCase().contains(q),
        )
        .toList();
  }
  // --- End Search Filter Logic ---

  @override
  Widget build(BuildContext context) {
    final list = _filteredHospitals;
    final displayCount = _currentMax.clamp(0, list.length);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hospitals',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: CustomTextFormField(
                controller: _searchController,
                hintText: 'Search hospitals by name or location',
                suffixIcon: Icon(Icons.search, color: AppColor.greenColor),
                onChanged: (v) {
                  setState(() {
                    _query = v.trim();
                    _currentMax = _pageSize.clamp(0, _filteredHospitals.length);
                  });
                },
              ),
            ),

            Expanded(
              child: ListView.builder(
                controller: _controller,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                // Add 1 to itemCount to show the loading indicator if loading more
                itemCount: displayCount + (_isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= displayCount) {
                    // Loading Indicator
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final hospital = list[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CustomContainerHospital(hospitalModel: hospital),
                  );
                },
              ),
            ),
            // Show a message if the list is empty after filtering
            if (list.isEmpty && _query.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No hospitals found matching your search.'),
              ),
            // Show end of list message
            if (!_isLoadingMore &&
                displayCount > 0 &&
                displayCount == list.length)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'End of list. Total: ${list.length}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomContainerHospital extends StatelessWidget {
  const CustomContainerHospital({super.key, required this.hospitalModel});
  final HospitalModel hospitalModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HospitalsDetailsScreen(hospital: hospitalModel),
        ),
      ),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100, width: 0.5),
          ),
          child: Row(
            children: [
              // Image Section (1/3 width)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: SizedBox(
                  width: 120,
                  height: 150,
                  child: Image.network(
                    hospitalModel.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 5),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    right: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Name
                      Text(
                        hospitalModel.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        hospitalModel.specialty,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColor.greenColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColor.greenColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              hospitalModel.locationAddress,

                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColor.greenColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            hospitalModel.is24Hours
                                ? Icons.check_circle
                                : Icons.access_time,
                            size: 14,
                            color: hospitalModel.is24Hours
                                ? AppColor.greenColor
                                : AppColor.darkGreyColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hospitalModel.is24Hours
                                ? 'Open 24 Hours'
                                : 'now: ${hospitalModel.openingTime}',
                            style: TextStyle(
                              fontSize: 13,
                              color: hospitalModel.is24Hours
                                  ? AppColor.greenColor
                                  : AppColor.darkGreyColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 14,
                            color: AppColor.greenColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hospitalModel.phoneNumber,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColor.greenColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
