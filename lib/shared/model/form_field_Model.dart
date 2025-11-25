import 'package:flutter/material.dart';

class FormFieldData {
  final String label;
  final String? labelSuffix;
  final String? hintText;
  final TextInputType keyboardType;
  final String? prefixText;

  final bool isDropdown;
  final List<String>? dropdownItems;

  final bool isFilePicker;
  final String? helperText;
  final String? helperActionText;

  final bool isPassword;
  final String? Function(String?)? validator;

  FormFieldData({
    required this.label,
    this.labelSuffix,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.prefixText,
    this.isDropdown = false,
    this.dropdownItems,
    this.isFilePicker = false,
    this.helperText,
    this.helperActionText,
    this.isPassword = false,
    this.validator,
  });
}
