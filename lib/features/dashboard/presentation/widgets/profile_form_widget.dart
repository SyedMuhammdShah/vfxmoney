// profile_form.dart
import 'package:flutter/material.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';
import 'package:vfxmoney/shared/widgets/input_field.dart';
import 'package:vfxmoney/shared/widgets/push_button.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for all fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _callingCodeController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nationalController = TextEditingController();
  final TextEditingController _placeOfBirthController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _identificationNumController =
      TextEditingController();

  String _selectedGender = 'Male';
  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Personal Information Section
            _buildSectionHeader('Personal Information'),
            const SizedBox(height: 16),

            // First Name & Middle Name
            Row(
              children: [
                Expanded(
                  child: AppInputField(
                    controller: _firstNameController,
                    hintText: 'First Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First name is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppInputField(
                    controller: _middleNameController,
                    hintText: 'Middle Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Middle name is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Last Name & Date of Birth
            Row(
              children: [
                Expanded(
                  child: AppInputField(
                    controller: _lastNameController,
                    hintText: 'Last Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppInputField(
                    controller: _dobController,
                    hintText: 'Date of Birth',
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date of birth is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Gender & Email Address
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    value: _selectedGender,
                    items: _genders,
                    hintText: 'Gender',
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppInputField(
                    controller: _emailController,
                    hintText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Address Section
            _buildSectionHeader('Address'),
            const SizedBox(height: 16),

            // Address Line 1
            AppInputField(
              controller: _addressLine1Controller,
              hintText: 'Address Line 1',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Address Line 1 is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Address Line 2
            AppInputField(
              controller: _addressLine2Controller,
              hintText: 'Address Line 2',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Address Line 2 is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Country & State
            Row(
              children: [
                Expanded(
                  child: AppInputField(
                    controller: _countryController,
                    hintText: 'Country',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Country is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppInputField(
                    controller: _stateController,
                    hintText: 'State',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'State is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // City & Postal Code
            Row(
              children: [
                Expanded(
                  child: AppInputField(
                    controller: _cityController,
                    hintText: 'City',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'City is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppInputField(
                    controller: _postalCodeController,
                    hintText: 'Postal Code',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Postal code is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Contact Information Section
            _buildSectionHeader('Contact Information'),
            const SizedBox(height: 16),

            // Calling Code & Mobile Number
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AppInputField(
                    controller: _callingCodeController,
                    hintText: 'Calling Code',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Calling code is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: AppInputField(
                    controller: _mobileNumberController,
                    hintText: 'Mobile Number',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mobile number is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Phone Number & National
            Row(
              children: [
                Expanded(
                  child: AppInputField(
                    controller: _phoneNumberController,
                    hintText: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppInputField(
                    controller: _nationalController,
                    hintText: 'National',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'National is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Additional Information Section
            _buildSectionHeader('Additional Information'),
            const SizedBox(height: 16),

            // Place Of Birth & Occupation
            Row(
              children: [
                Expanded(
                  child: AppInputField(
                    controller: _placeOfBirthController,
                    hintText: 'Place Of Birth',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Place of birth is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppInputField(
                    controller: _occupationController,
                    hintText: 'Occupation',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Occupation is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Employee ID & Identification Num
            Row(
              children: [
                Expanded(
                  child: AppInputField(
                    controller: _employeeIdController,
                    hintText: 'Employee ID',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Employee ID is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppInputField(
                    controller: _identificationNumController,
                    hintText: 'Identification Num',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Identification number is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Update Button
            AppSubmitButton(title: 'Update', onTap: _updateProfile),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.bgGreyColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AppText(
        title,
        fontSize: 14,
        color: Colors.white,
        textStyle: 'jb',
        w: FontWeight.w600,
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required String hintText,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.bgGreyColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greytextColor.withOpacity(0.3)),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: AppText(
              value,
              fontSize: 14,
              color: Colors.white,
              textStyle: 'jb',
            ),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          hintStyle: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 14,
            color: AppColors.greytextColor,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        dropdownColor: AppColors.bgGreyColor,
        style: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 14,
          color: Colors.white,
        ),
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.greytextColor),
        isExpanded: true,
      ),
    );
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _callingCodeController.dispose();
    _mobileNumberController.dispose();
    _phoneNumberController.dispose();
    _nationalController.dispose();
    _placeOfBirthController.dispose();
    _occupationController.dispose();
    _employeeIdController.dispose();
    _identificationNumController.dispose();
    super.dispose();
  }
}
