import 'package:cure_link/widgets/custom_continer_day.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomListViewSeparatedDay extends StatefulWidget {
  final ValueChanged<String> onDaySelected;
  const CustomListViewSeparatedDay({super.key, required this.onDaySelected});

  @override
  State<CustomListViewSeparatedDay> createState() =>
      _CustomListViewSeparatedDayState();
}

class _CustomListViewSeparatedDayState
    extends State<CustomListViewSeparatedDay> {
  List<Map<String, String>> nextSevenDays = [];
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _generateNextSevenDays();
  }

  void _generateNextSevenDays() {
    DateTime now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      nextSevenDays.add({
        'day': DateFormat('E').format(date),
        'date': DateFormat('d').format(date),
        'fullDayString': DateFormat('EEE, MMM d').format(date).toString(),
      });
    }
  }

  void _onDaySelected(int index) {
    setState(() {
      final bool currentlySelected = selectedIndex == index;

      selectedIndex = currentlySelected ? null : index;

      String? selectedDayString = currentlySelected
          ? ''
          : nextSevenDays[index]['fullDayString'];

      // إرسال القيمة المختارة للأب
      widget.onDaySelected(selectedDayString ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: nextSevenDays.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final bool isSelected = selectedIndex == index;

          return CustomContinerDay(
            day: nextSevenDays[index]['day']!,
            date: nextSevenDays[index]['date']!,
            isSelected: isSelected,
            onTap: () => _onDaySelected(index),
          );
        },
      ),
    );
  }
}
