// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:vfxmoney/core/constants/enums.dart';
// import 'package:vfxmoney/core/extensions/text_theme_extension.dart';
// import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
// import 'package:vfxmoney/core/services/service_locator.dart';
// import 'package:vfxmoney/core/services/storage_service.dart';
// import 'package:vfxmoney/core/validators/form_validators.dart';
// import 'package:vfxmoney/core/validators/phone_formatter.dart';
// import 'package:vfxmoney/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:vfxmoney/features/auth/presentation/bloc/auth_events.dart';
// import 'package:vfxmoney/features/auth/presentation/bloc/auth_state.dart';
// import 'package:vfxmoney/shared/widgets/custom_appbar.dart';
// import 'package:vfxmoney/shared/widgets/custom_loader.dart';
// import 'package:vfxmoney/shared/widgets/image_picker.dart';
// import 'package:vfxmoney/shared/widgets/input_field.dart';
// import 'package:vfxmoney/shared/widgets/phone_input_field.dart';
// import 'package:vfxmoney/shared/widgets/push_button.dart';
// import 'package:vfxmoney/shared/widgets/social_button.dart';
// import 'package:vfxmoney/shared/widgets/toast.dart';
// import '../../../../core/navigation/route_enums.dart';
// import '../../../../core/constants/app_icons.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   String? idToken;
//   final loader = CustomLoader();

//   void handleLogin() {
//     context.goNamed(Routes.login.name);
//   }

//   Future<void> handleSubmit() async {
//     if (selectedImagePath == null) {
//       errorToast(msg: "Profile image is required");
//       return;
//     }

//     if (!_formKey.currentState!.validate()) return;

//     final email = emailController.text.trim();
//     final phone = PhoneFormatter.toE164(phoneController.text.trim());
//     final name = nameController.text.trim();

//     loader.show(context);

//     try {
//       // UserCredential userCredential = await FirebaseAuth.instance
//       //     .createUserWithEmailAndPassword(email: email, password: email);
//       final idToken = await createOrSignInUser(email);
//       // final idToken = await userCredential.user!.getIdToken();

//       final params = RegisterProfileParams(
//         email: email,
//         phone: phone,
//         profilePicture: File(selectedImagePath!),
//         name: name,
//         idToken: idToken ?? '',
//         role: "user",
//       );

//       // 3️⃣ Trigger signup event
//       if (mounted) {
//         context.read<AuthBloc>().add(SignUpEvent(params));
//       }
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'email-already-in-use') {
//         errorToast(msg: "Email already registered");
//       } else {
//         errorToast(msg: "Firebase error: ${e.message}");
//       }
//     } catch (e) {
//       errorToast(msg: "Failed to register: $e");
//     } finally {
//       if (mounted) {
//         loader.hide();
//       }
//     }
//   }

//   String? selectedImagePath;

//   Future<void> _selectImage() async {
//     final imagePath = await ImagePickerHelper.pickImage(context);
//     if (imagePath != null) {
//       setState(() => selectedImagePath = imagePath);
//       showToast(msg: 'Profile picture selected successfully!');
//     }
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuthBloc, AuthState>(
//       listener: (context, state) {
//         if (state is Authenticated) {
//           locator<StorageService>().setToken(state.authUser.token);

//           context.goNamed(
//             Routes.verifyAccount.name,
//             extra: {"source": "signup", "authUser": state.authUser},
//           );
//         } else if (state is AuthError) {
//           errorToast(msg: state.message);
//         }
//       },
//       builder: (context, state) {
//         final isLoading = state is AuthLoading;

//         return SafeArea(
//           child: Scaffold(
//             body: Stack(
//               children: [
//                 CustomScrollView(
//                   slivers: [
//                     /// AppBar becomes scrollable with the body
//                     SliverToBoxAdapter(
//                       // child: RoundedAppBarWithProfile(
//                       //   height: 170,
//                       //   showImagePicker: true,
//                       //   onImagePickerPressed: _selectImage,
//                       //   title: "Signup",
//                       //   titleSize: 25,
//                       //   subTitle: "Please enter the details below to signup",
//                       //   subTitleSize: 13,
//                       //   alignTitleCenter: true,
//                       //   showNameLocation: false,
//                       //   profileImage: selectedImagePath,
//                       //   showIcons: false,
//                       //   titleColor: Colors.white,
//                       // ),
//                     ),

//                     /// Form content scrolls below it
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: const EdgeInsets.all(15),
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               const SizedBox(height: 20),
//                               Text(
//                                 "Full Name",
//                                 style: context.labelMedium?.copyWith(),
//                               ),
//                               const SizedBox(height: 10),

//                               /// Full Name
//                               AppInputField(
//                                 controller: nameController,
//                                 hintText: 'Enter Full Name',
//                                 validator: FormValidators.validateFullName,
//                               ),
//                               const SizedBox(height: 20),

//                               Text(
//                                 "Email",
//                                 style: context.labelMedium?.copyWith(),
//                               ),
//                               const SizedBox(height: 10),

//                               AppInputField(
//                                 controller: emailController,
//                                 hintText: 'Enter Your Email',
//                                 keyboardType: TextInputType.emailAddress,
//                                 validator: FormValidators.validateEmail,
//                               ),
//                               const SizedBox(height: 20),

//                               Text(
//                                 "Phone Number",
//                                 style: context.labelMedium?.copyWith(),
//                               ),
//                               const SizedBox(height: 10),

//                               PhoneInputField(
//                                 controller: phoneController,
//                                 hintText: 'Add Phone Number',
//                                 validator: FormValidators.validatePhoneNumber,
//                               ),

//                               const SizedBox(height: 30),

//                               AppSubmitButton(
//                                 title: "Signup",
//                                 onTap: isLoading
//                                     ? () {}
//                                     : handleSubmit, // Disable when loading
//                               ),

//                               Padding(
//                                 padding: const EdgeInsets.all(15.0),
//                                 child: Text.rich(
//                                   textAlign: TextAlign.center,
//                                   TextSpan(
//                                     children: [
//                                       TextSpan(
//                                         text: "Already have an account? ",
//                                         style: context.bodyMedium?.copyWith(),
//                                       ),
//                                       TextSpan(
//                                         text: "login now",
//                                         recognizer: TapGestureRecognizer()
//                                           ..onTap = isLoading
//                                               ? null
//                                               : handleLogin,
//                                         style: context.titleSmallBold?.copyWith(
//                                           color: Theme.of(
//                                             context,
//                                           ).colorScheme.primary,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),

//                               const SizedBox(height: 20),

//                               Text.rich(
//                                 textAlign: TextAlign.center,
//                                 TextSpan(
//                                   children: [
//                                     const TextSpan(
//                                       text: "I accept the ",
//                                       style: TextStyle(
//                                         color: Colors.black54,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     TextSpan(
//                                       text: "Terms & Conditions",
//                                       style: TextStyle(
//                                         color: Theme.of(
//                                           context,
//                                         ).colorScheme.primary,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const TextSpan(
//                                       text: " and ",
//                                       style: TextStyle(
//                                         color: Colors.black54,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     TextSpan(
//                                       text: "Privacy Policy",
//                                       style: TextStyle(
//                                         color: Theme.of(
//                                           context,
//                                         ).colorScheme.primary,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 30),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 /// Loading Overlay
//                 if (isLoading)
//                   Container(
//                     color: Colors.black.withValues(alpha: 0.5),
//                     child: Center(
//                       child: Card(
//                         margin: const EdgeInsets.symmetric(horizontal: 50),
//                         child: Padding(
//                           padding: const EdgeInsets.all(24.0),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               CircularProgressIndicator(
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   Theme.of(context).colorScheme.primary,
//                                 ),
//                               ),
//                               const SizedBox(height: 16),
//                               const Text(
//                                 'Creating your account...',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<String?> createOrSignInUser(String email) async {
//     try {
//       // Step 1: Try creating a new user
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: "123456");

//       return await userCredential.user?.getIdToken();
//     } on FirebaseAuthException catch (e) {
//       // Step 2: If already exists, sign in instead
//       if (e.code == 'email-already-in-use') {
//         UserCredential userCredential = await FirebaseAuth.instance
//             .signInWithEmailAndPassword(email: email, password: "123456");

//         return await userCredential.user?.getIdToken();
//       } else {
//         // Other Firebase errors
//         throw Exception("Firebase error: ${e.message}");
//       }
//     } catch (e) {
//       throw Exception("Unexpected error: $e");
//     }
//   }
// }
