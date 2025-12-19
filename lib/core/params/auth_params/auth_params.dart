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

// Register Parameters
class RegisterParams {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String route;

  RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.route = 'auth.register',
  });

  /// 🔥 Backend expects `name`, not first/last separately
  String get fullName => '${firstName.trim()} ${lastName.trim()}'.trim();

  Map<String, dynamic> toJson() => {
    'name': fullName, // ✅ concatenated here
    'email': email.trim(),
    'password': password,
    'password_confirmation': passwordConfirmation,
    'route': route,
  };
}

// OTP Verification Parameters

class VerifyEmailOtpParams {
  final String email;
  final String code;
  final String route;

  VerifyEmailOtpParams({
    required this.email,
    required this.code,
    this.route = 'user.verify_email_code',
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'code': code,
    'route': route,
  };
}
