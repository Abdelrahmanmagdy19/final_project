import 'package:cure_link/widgets/custom_container_houre.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomHoursListView extends StatefulWidget {
  final ValueChanged<String> onTimeSelected;
  const CustomHoursListView({super.key, required this.onTimeSelected});

  @override
  State<CustomHoursListView> createState() => _CustomHoursListViewState();
}

class _CustomHoursListViewState extends State<CustomHoursListView> {
  int? selectedIndex;
  final List<String> _allHours = _generateHours(startHour: 8, endHour: 19);

  static List<String> _generateHours({
    required int startHour,
    required int endHour,
  }) {
    List<String> hours = [];
    for (int h = startHour; h <= endHour; h++) {
      DateTime time = DateTime(2023, 1, 1, h, 0);
      hours.add(DateFormat('hh:mm a').format(time));
    }
    return hours;
  }

  void _onTimeSelected(int index, bool isAvailable) {
    if (isAvailable) {
      setState(() {
        final bool currentlySelected = selectedIndex == index;

        selectedIndex = currentlySelected ? null : index;

        String? selectedTimeString = currentlySelected ? '' : _allHours[index];

        widget.onTimeSelected(selectedTimeString);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 15,
        childAspectRatio: 2.7,
      ),
      itemCount: _allHours.length,
      itemBuilder: (context, index) {
        final String currentTime = _allHours[index];
        const bool isAvailable = true;
        final bool isSelected = selectedIndex == index;
        return CustomContainerHoure(
          time: currentTime,
          isAvailable: isAvailable,
          isSelected: isSelected,
          onTap: () => _onTimeSelected(index, isAvailable),
        );
      },
    );
  }
}
