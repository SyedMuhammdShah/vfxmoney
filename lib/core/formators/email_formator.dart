String maskEmail(String? email) {
  if (email == null || !email.contains('@')) return '';

  final parts = email.split('@');
  final username = parts[0];
  final domain = parts[1];

  if (username.isEmpty) return '****@$domain';

  if (username.length <= 2) {
    // If username is too short, mask almost all of it
    return '${username[0]}****@$domain';
  }

  final start = username.substring(0, 2);
  final end = username.substring(username.length - 1);
  return '$start****$end@$domain';
}
