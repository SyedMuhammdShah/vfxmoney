class LoginParams {
  final String email;

  const LoginParams({required this.email});

  Map<String, dynamic> toJson() {
    return {'email': email, 'role': 'user'};
  }
}
