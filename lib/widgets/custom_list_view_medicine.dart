import 'package:cure_link/models/medicine_model.dart';
import 'package:cure_link/widgets/custom_medicine_container.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CustomListViewMedicine extends StatefulWidget {
  final List<MedicineModel> medicationList;

  const CustomListViewMedicine({super.key, required this.medicationList});

  @override
  State<CustomListViewMedicine> createState() => _CustomListViewMedicineState();
}

class _CustomListViewMedicineState extends State<CustomListViewMedicine> {
  final ScrollController _scrollController = ScrollController();
  static const int _chunkSize = 5;
  int _itemsToDisplay = _chunkSize;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _itemsToDisplay = min(_chunkSize, widget.medicationList.length);
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant CustomListViewMedicine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.medicationList.length != oldWidget.medicationList.length) {
      setState(() {
        _itemsToDisplay = min(_itemsToDisplay, widget.medicationList.length);
        if (_itemsToDisplay == 0) {
          _itemsToDisplay = min(_chunkSize, widget.medicationList.length);
        }
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 60 &&
        !_isLoadingMore) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_itemsToDisplay >= widget.medicationList.length) return;

    setState(() => _isLoadingMore = true);

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _itemsToDisplay = min(
          widget.medicationList.length,
          _itemsToDisplay + _chunkSize,
        );
        _isLoadingMore = false;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isListEmpty = widget.medicationList.isEmpty;

    final bool hasMore = _itemsToDisplay < widget.medicationList.length;
    final int itemCount = isListEmpty
        ? 0
        : _itemsToDisplay + ((hasMore || _isLoadingMore) ? 1 : 0);

    return SizedBox(
      height: 165,
      child: isListEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Text(
                  'No matching medications found.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            )
          : ListView.separated(
              controller: _scrollController,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                if (index >= _itemsToDisplay) {
                  return SizedBox(
                    width: 64,
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                  );
                }
                return CustomMedicineContainer(
                  medicineModel: widget.medicationList[index],
                );
              },
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
            ),
    );
  }
}
