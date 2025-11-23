class PhoneFormatter {
  /// For displaying in UI (e.g. +1 (234) 567-890)
  static String formatUS(String phone) {
    if (phone.isEmpty) return '';

    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length < 10) return phone;

    final clean = digits.substring(digits.length - 10);
    final areaCode = clean.substring(0, 3);
    final prefix = clean.substring(3, 6);
    final lineNumber = clean.substring(6, 10);

    return '+1 ($areaCode) $prefix-$lineNumber';
  }

  /// For sending to backend (e.g. +1234567890)
  static String toE164(String phone) {
    if (phone.isEmpty) return '';

    final digits = phone.replaceAll(RegExp(r'\D'), '');

    // Always return +1 followed by 10 digits
    if (digits.length >= 10) {
      final clean = digits.substring(digits.length - 10);
      return '+1$clean';
    }

    return '+1$digits';
  }
}
