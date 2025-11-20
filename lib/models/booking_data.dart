class BookingData {
  final String? selectedDate;
  final String? selectedTime;
  final String? pain;

  BookingData({this.selectedDate, this.selectedTime, this.pain});

  bool get isReadyToBook =>
      selectedDate != null &&
      selectedTime != null &&
      selectedDate!.isNotEmpty &&
      selectedTime!.isNotEmpty;

  String get formattedDateTime {
    if (selectedDate != null && selectedTime != null) {
      return "$selectedDate at $selectedTime";
    }
    return "Date/Time not selected";
  }
}
