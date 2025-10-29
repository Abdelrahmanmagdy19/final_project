class AppValidation {
  static RegExp emailExp = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
  static RegExp passwordExp = RegExp(r'^.{6,}$');
  static RegExp nameExp = RegExp(r"^[a-zA-Z\s]+$");
  static RegExp phoneExp = RegExp(r'^[0-9]{10,15}$');
  static RegExp urlExp = RegExp(
    r'^(http|https):\/\/[a-zA-Z0-9-\.]+\.[a-zA-Z]{2,}(\/\S*)?$',
    caseSensitive: false,
  );
  static RegExp numberExp = RegExp(r'^\d+$');
  static RegExp aboutExp = RegExp(r'^.{10,}$');

  static String? validation({
    required String? value,
    required ValidationType type,
  }) {
    final String trimmedValue = value?.trim() ?? '';

    if (type == ValidationType.email) {
      if (trimmedValue.isEmpty) {
        return 'Email is required';
      } else if (!emailExp.hasMatch(trimmedValue)) {
        return 'Please enter a valid email address';
      }
    } else if (type == ValidationType.password) {
      if (trimmedValue.isEmpty) {
        return 'Password is required';
      } else if (!passwordExp.hasMatch(trimmedValue)) {
        return 'Password must be at least 6 characters long';
      }
    } else if (type == ValidationType.name) {
      if (trimmedValue.isEmpty) {
        return 'Name is required';
      } else if (!nameExp.hasMatch(trimmedValue)) {
        return 'Please enter a valid name (letters and spaces only)';
      }
    } else if (type == ValidationType.phone) {
      if (trimmedValue.isEmpty) {
        return 'Phone number is required';
      } else if (!phoneExp.hasMatch(trimmedValue)) {
        return 'Please enter a valid phone number (10-15 digits)';
      }
    } else if (type == ValidationType.url) {
      if (trimmedValue.isEmpty) {
        return 'URL is required';
      } else if (!urlExp.hasMatch(trimmedValue)) {
        return 'Please enter a valid URL (starting with http/https)';
      }
    } else if (type == ValidationType.number) {
      if (trimmedValue.isEmpty) {
        return 'This field is required';
      } else if (!numberExp.hasMatch(trimmedValue)) {
        return 'Please enter a valid whole number';
      }
    } else if (type == ValidationType.about) {
      if (trimmedValue.isEmpty) {
        return 'This field is required';
      } else if (!aboutExp.hasMatch(trimmedValue)) {
        return 'Please enter at least 10 characters';
      }
    }

    return null;
  }
}

enum ValidationType { email, password, name, phone, url, number, about }
