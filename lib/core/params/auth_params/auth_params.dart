// Login Parameters
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

// Send Verification Email Parameters
class SendVrfEmail {
  final String email;
  final String route;

  SendVrfEmail({
    required this.email,
    this.route = 'auth.send_verification_email',
  });

  Map<String, dynamic> toJson() => {'email': email, 'route': route};
}
