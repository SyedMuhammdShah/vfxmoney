/// form_validators.dart
class FormValidators {
  // --- FULL NAME VALIDATOR ---
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Full name is required";
    }
    if (value.trim().length < 3) {
      return "Full name must be at least 3 characters";
    }
    if (!RegExp(r'^[A-Za-z]').hasMatch(value)) {
      return "Full name must start with a letter";
    }
    if (value.length > 35) {
      return "Full name cannot exceed 35 characters";
    }
    if (!RegExp(r"^[A-Za-z][A-Za-z\s'\-]*$").hasMatch(value)) {
      return "Full name can only contain letters and spaces";
    }
    return null;
  }

  // --- EMAIL VALIDATOR ---
  // Validates that the input is a valid email address
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }

    // Check for leading/trailing spaces
    if (value != value.trim()) {
      return 'Email cannot start or end with spaces';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length > 254) {
      return 'Email address is too long';
    }

    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);

    if (!regex.hasMatch(trimmedValue)) {
      return 'Please enter a valid email address';
    }

    // Disallow invalid dot positions or sequences
    if (trimmedValue.startsWith('.') ||
        trimmedValue.endsWith('.') ||
        trimmedValue.contains('..') ||
        trimmedValue.contains('@.') ||
        trimmedValue.contains('.@')) {
      return 'Invalid email format';
    }

    return null;
  }

  // --- PHONE VALIDATOR ---
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digit characters like ( ) - and spaces
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    // Check if there are exactly 10 digits
    if (digitsOnly.length != 10) {
      return 'Enter a valid phone number';
    }

    return null;
  }
}
