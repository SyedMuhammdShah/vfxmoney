import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';
import 'package:vfxmoney/shared/widgets/gap.dart';
import 'package:vfxmoney/shared/widgets/input_field.dart';

class PhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hintText;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.validator,
    this.hintText = 'Add phone number',
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  String selectedCountryCode = '+1';
  String selectedCountryFlag = '🇺🇸';

  // Common country list
  final List<Map<String, String>> countryCodes = [
    {'code': '+1', 'flag': '🇺🇸', 'country': 'US'},
    {'code': '+1', 'flag': '🇨🇦', 'country': 'CA'},
    {'code': '+44', 'flag': '🇬🇧', 'country': 'UK'},
    {'code': '+91', 'flag': '🇮🇳', 'country': 'IN'},
    {'code': '+33', 'flag': '🇫🇷', 'country': 'FR'},
    {'code': '+49', 'flag': '🇩🇪', 'country': 'DE'},
    {'code': '+81', 'flag': '🇯🇵', 'country': 'JP'},
    {'code': '+86', 'flag': '🇨🇳', 'country': 'CN'},
    {'code': '+61', 'flag': '🇦🇺', 'country': 'AU'},
    {'code': '+55', 'flag': '🇧🇷', 'country': 'BR'},
  ];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_formatPhoneNumber);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_formatPhoneNumber);
    super.dispose();
  }

  /// 🧠 Formats number like (123) 456-7890
  void _formatPhoneNumber() {
    String digitsOnly = widget.controller.text.replaceAll(RegExp(r'\D'), '');
    String formatted = _formatAsUSPhone(digitsOnly);

    if (formatted != widget.controller.text) {
      final cursorPos = formatted.length;
      widget.controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: cursorPos),
      );
    }
  }

  /// Formats digits → (XXX) XXX-XXXX
  String _formatAsUSPhone(String digits) {
    if (digits.isEmpty) return '';
    if (digits.length <= 3) return '(${digits.substring(0, digits.length)}';
    if (digits.length <= 6) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3)}';
    }
    if (digits.length <= 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    }
    return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6, 10)}';
  }

  /// ✅ Clean backend value: +11234567890
  String getFullPhoneNumber() {
    final digits = widget.controller.text.replaceAll(RegExp(r'\D'), '');
    return '$selectedCountryCode$digits';
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 400,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Country',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: countryCodes.length,
                  itemBuilder: (context, index) {
                    final country = countryCodes[index];
                    return ListTile(
                      leading: Text(
                        country['flag']!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        '${country['country']} ${country['code']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selectedCountryCode = country['code']!;
                          selectedCountryFlag = country['flag']!;
                          widget.controller.text = '';
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: _showCountryPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.melodicWhisper),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      selectedCountryFlag,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Gap(10),
                    Text(
                      selectedCountryCode,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),

                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Expanded(
        //   child: InputField(
        //     controller: widget.controller,
        //     validator: widget.validator,
        //     hintText: widget.hintText,
        //     keyboardType: TextInputType.phone,
        //     fillColor: Colors.grey[100]!,
        //     inputFormatters: [
        //       FilteringTextInputFormatter.digitsOnly, // Only digits allowed
        //       LengthLimitingTextInputFormatter(11),    // Limit to 11 digits
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
