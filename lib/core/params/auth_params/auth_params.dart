class LoginParams {
  final String email;
  final String password;
  final String route;

  LoginParams({
    required this.email,
    required this.password,
    this.route = 'auth.login',
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'route': route,
      };
}
