class VerifyLoginOtpParams {
  final String otp;
  final String email;
  final String role;

  VerifyLoginOtpParams({
    required this.otp,
    required this.email,
    this.role = "user", // default role
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "otp": otp,
        "role": role,
      };
}
