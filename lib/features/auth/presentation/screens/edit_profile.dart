import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vfxmoney/core/extensions/text_theme_extension.dart';
import 'package:vfxmoney/core/params/auth_params/auth_params.dart';
import 'package:vfxmoney/core/services/service_locator.dart';
import 'package:vfxmoney/core/services/storage_service.dart';
import 'package:vfxmoney/core/validators/form_validators.dart';
import 'package:vfxmoney/core/validators/phone_formatter.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_events.dart';
import 'package:vfxmoney/features/auth/presentation/bloc/auth_state.dart';
import 'package:vfxmoney/shared/widgets/custom_appbar.dart';
import 'package:vfxmoney/shared/widgets/custom_loader.dart';
import 'package:vfxmoney/shared/widgets/image_picker.dart';
import 'package:vfxmoney/shared/widgets/input_field.dart';
import 'package:vfxmoney/shared/widgets/push_button.dart';
import 'package:vfxmoney/shared/widgets/toast.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final StorageService _storage = locator<StorageService>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  String? profileImage;
  String? selectedImagePath;
  final CustomLoader loader = CustomLoader();
  @override
  void initState() {
    super.initState();
    final user = _storage.getUser;

    nameController = TextEditingController(text: user?.name ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    phoneController = TextEditingController(
      text: PhoneFormatter.formatUS(user?.phone ?? ''),
    );
    profileImage = user?.profilePicture ?? '';
  }

  Future<void> _selectImage() async {
    final imagePath = await ImagePickerHelper.pickImage(context);
    if (imagePath != null) {
      setState(() => selectedImagePath = imagePath);
      showToast(msg: 'Profile picture selected successfully!');
    }
  }

  Future<void> handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    loader.show(context);

    final params = UpdateProfileParams(
      name: nameController.text.trim(),
      profileImage: selectedImagePath != null && selectedImagePath!.isNotEmpty
          ? File(selectedImagePath!)
          : null,
    );

    if (mounted) {
      context.read<AuthBloc>().add(UpdateProfileEvent(params));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayImage = selectedImagePath ?? profileImage;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is ProfileUpdated) {
          loader.hide();
          showToast(msg: "Profile updated successfully!");

          if (context.mounted) {
            Navigator.pop(context, true);
          }
        } else if (state is AuthError) {
          loader.hide();
          showToast(msg: state.message);
        } else if (state is AuthLoading) {
          // Already handled by CustomLoader.show()
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return SafeArea(
          child: Scaffold(
            // appBar: const RoundedAppBarWithProfile(
            //   title: 'Edit Profile',
            //   height: 50,
            //   showBackButton: true,
            //   alignTitleCenter: true,
            //   showNameLocation: false,
            //   showProfileImage: false,
            // ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        // Profile Image Picker
                        GestureDetector(
                          onTap: isLoading ? null : _selectImage,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage:
                                    (displayImage != null &&
                                        displayImage.isNotEmpty)
                                    ? (displayImage.startsWith('http')
                                          ? NetworkImage(displayImage)
                                          : FileImage(File(displayImage))
                                                as ImageProvider)
                                    : null,
                                child:
                                    (displayImage == null ||
                                        displayImage.isEmpty)
                                    ? const Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: const Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Full Name",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AppInputField(
                          controller: nameController,
                          hintText: 'Full Name',
                          validator: FormValidators.validateFullName,
                        ),

                        const SizedBox(height: 20),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AppInputField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Email',
                          validator: FormValidators.validateEmail,
                        ),
                        Text(
                          'Your email address cannot be changed for security reasons',
                          style: context.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Phone Number",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AppInputField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          hintText: 'Phone Number',
                          validator: FormValidators.validatePhoneNumber,
                          // validator: FormValidators.validatePhoneNumber,
                        ),
                        Text(
                          'Your phone number cannot be changed for security reasons',
                          style: context.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),

                        const SizedBox(height: 40),

                        AppSubmitButton(
                          title: "Save Changes",
                          onTap: () {
                            handleSave();
                          },
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),

                // Overlay Loader
                if (isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.4),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
