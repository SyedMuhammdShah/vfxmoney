part of '../app_router.dart';

final authRoutes = [
  GoRoute(
    name: Routes.login.name,
    path: Routes.login.path,
    builder: (context, state) => Theme(
      data: AppTheme.dark, // Force dark theme
      child: const VortexAuthScreen(),
    ),
    pageBuilder: GoTransitions.openUpwards.call,
  ),
 
  GoRoute(
    name: Routes.forgotPass.name,
    path: Routes.forgotPass.path,
    builder: (context, state) => const ForgotPassScreen(),
  ),
  GoRoute(
    name: Routes.changePass.name,
    path: Routes.changePass.path,
    builder: (context, state) => const ChangePassScreen(),
  ),
  GoRoute(
    name: Routes.changePhoneNumberSuccess.name,
    path: Routes.changePhoneNumberSuccess.path,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;

      return SuccessScreen(
        title: extra?['title'] ?? "Phone Number Updated!",
        subtitle:
            extra?['subtitle'] ??
            "Your phone number has been updated successfully.",
        showButton: true,
        buttonText: "Home",
        onButtonPressed: () {
          context.goNamed(Routes.dashboard.name);
        },
      );
    },
  ),

  // User Profile
  GoRoute(
    path: Routes.userProfile.path,
    name: Routes.userProfile.name,
    builder: (context, state) => const UserProfileScreen(),
  ),

  // GoRoute(
  //   name: Routes.enableLocationScreen.name,
  //   path: Routes.enableLocationScreen.path,
  //   builder: (context, state) => const EnableLocationScreen(),
  // ),
  // GoRoute(
  //   name: Routes.addressSelection.name,
  //   path: Routes.addressSelection.path,
  //   builder: (context, state) {
  //     final extras = state.extra;
  //     String type = '';
  //     if (extras is Map<String, dynamic>) {
  //       type = extras['type'] ?? '';
  //     } else if (extras is String) {
  //       type = extras;
  //     }

  //     return AddressSelectionScreen(type: type);
  //   },
  // ),

  // GoRoute(
  //   name: Routes.addAddress.name,
  //   path: Routes.addAddress.path,
  //   builder: (context, state) {
  //     final extras = state.extra as Map<String, dynamic>?;

  //     final bool isEdit = extras?['isEdit'] ?? false;
  //     final existingAddress = extras?['existingAddress'];

  //     return AddAddressScreen(isEdit: isEdit, existingAddress: existingAddress);
  //   },
  // ),

  GoRoute(
    name: Routes.loginSuccess.name,
    path: Routes.loginSuccess.path,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;

      return SuccessScreen(
        title: extra?['title'] ?? "Verification Successful!",
        subtitle:
            extra?['subtitle'] ??
            "You have successfully verified your account.",
        showButton: false,
      );
    },
  ),

  GoRoute(
    name: Routes.deleteAccountSuccess.name,
    path: Routes.deleteAccountSuccess.path,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;

      return SuccessScreen(
        title: extra?['title'] ?? "Account Deleted!",
        subtitle:
            extra?['subtitle'] ?? "Your account has been deleted succesfully",
        showButton: false,
      );
    },
  ),

  GoRoute(
    name: Routes.onboarding.name,
    path: Routes.onboarding.path,
    builder: (context, state) => const OnboardingScreen(),
  ),
];
