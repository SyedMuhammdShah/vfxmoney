import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseService {
  // Private constructor
  FirebaseService._privateConstructor();

  // Static instance
  static final FirebaseService _instance =
      FirebaseService._privateConstructor();

  // Factory constructor to return the same instance
  factory FirebaseService() {
    return _instance;
  }
  // final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile'],
  // clientId: Platform.isIOS ?
  //     '951292838186-42jgsckaio3nmlh8v2d7oar4a2b8b8t5.apps.googleusercontent.com'
  //     : null
  // );

  Future<String?> getIdToken() async {
    try {
      log('Getting ID token...');
      User? user = FirebaseAuth.instance.currentUser;
      String? idToken = await user?.getIdToken();
      log('ID token: $idToken');
      return idToken;
    } catch (e) {
      log('Error getting ID token: $e');
      return null;
    }
  }

  // Sign in with Google
  // This method requires the GoogleSignIn plugin to be installed and configured correctly.
  // Future<UserCredential?> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
  //     final GoogleSignInAuthentication? gAuth =
  //         gUser == null ? null : await gUser.authentication;

  //     if (gUser == null) {
  //       return null;
  //     }

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: gAuth?.accessToken,
  //       idToken: gAuth?.idToken,
  //     );

  //     UserCredential response = await FirebaseAuth.instance
  //         .signInWithCredential(credential);
  //     return response;
  //   } on Exception {
  //     rethrow;
  //   }
  // }

  // Sign in with Apple
  // This method requires the SignInWithApple plugin to be installed and configured correctly.
  // Future<UserCredential?> signInWithApple() async {
  //   try {
  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );

  //     final status = await SignInWithApple.getCredentialState(
  //       appleCredential.userIdentifier!,
  //     );

  //     if (status == CredentialState.authorized) {
  //       final oAuthProvider = OAuthProvider("apple.com");
  //       final oAuthCredential = oAuthProvider.credential(
  //         idToken: appleCredential.identityToken,
  //         accessToken: appleCredential.authorizationCode,
  //       );

  //       final authResult = await FirebaseAuth.instance.signInWithCredential(
  //         oAuthCredential,
  //       );

  //       return authResult;
  //     } else {
  //       // Optional: log revoked or not found
  //       log("Apple Sign-In status: ${status.name}");
  //       return null;
  //     }
  //   } on SignInWithAppleAuthorizationException catch (e) {
  //     if (e.code == AuthorizationErrorCode.canceled) {
  //       log("Apple Sign-In cancelled by user");
  //       return null;
  //     } else {
  //       log("Apple Sign-In error: ${e.code} - ${e.message}");
  //       return null;
  //     }
  //   } catch (e) {
  //     log("Unexpected Apple Sign-In error: $e");
  //     return null;
  //   }
  // }

  Future<void> logout() async {
   // await _googleSignIn.signOut();
    await _instance.logout();
  }
}
