import 'dart:convert';

class ApiErrorParser {
  static String extractMessage(dynamic raw) {
    try {
      // Case 1: Already a Map
      if (raw is Map<String, dynamic>) {
        if (raw['message'] != null) {
          return raw['message'].toString();
        }

        // Laravel validation errors
        if (raw['errors'] is Map) {
          final errors = raw['errors'] as Map;
          final firstKey = errors.keys.first;
          final firstError = errors[firstKey];
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }
        }
      }

      // Case 2: String (JSON or php serialized already unwrapped)
      if (raw is String) {
        final parsed = jsonDecode(raw);
        if (parsed is Map) {
          return extractMessage(parsed);
        }
      }
    } catch (_) {}

    return 'Something went wrong. Please try again.';
  }
}
