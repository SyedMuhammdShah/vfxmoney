import 'package:flutter/material.dart';
import 'package:vfxmoney/core/extensions/text_theme_extension.dart';
import 'package:vfxmoney/core/extensions/theme_extension.dart';

import '../../core/constants/app_colors.dart';

class DropdownField<T> extends StatelessWidget {
  const DropdownField({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.prefix,
    this.suffix,
    this.enabled = true,
    this.focusNode,
    this.fillColor = AppColors.melodicWhisper,
    this.borderColor = AppColors.melodicWhisper,
    this.focusedBorderColor,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 18,
    ),
    this.validator,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? hintText;
  final String? labelText;

  final IconData? prefixIcon;
  final Widget? prefix;
  final Widget? suffix;

  final bool enabled;
  final FocusNode? focusNode;

  final Color fillColor;
  final Color borderColor;
  final Color? focusedBorderColor;
  final EdgeInsets contentPadding;

  final String? Function(T?)? validator;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(color: color, width: 1.2),
  );

  @override
  Widget build(BuildContext context) {
    final prefixWidget =
        prefix ?? (prefixIcon != null ? Icon(prefixIcon, size: 20) : null);

    Widget field = DropdownButtonFormField<T>(
      value: value,
      focusNode: focusNode,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: context.contentStyle?.copyWith(
          fontSize: context.bodyMedium?.fontSize,
        ),
        isDense: true,
        filled: true,
        fillColor: fillColor,
        contentPadding: contentPadding,
        prefixIcon: prefixWidget != null
            ? Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: prefixWidget,
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: suffix,
        enabledBorder: _border(borderColor),
        disabledBorder: _border(borderColor.withValues(alpha:0.6)),
        focusedBorder: focusedBorderColor != null
            ? _border(focusedBorderColor!)
            : null,
        errorBorder: _border(context.colors.primary),
        focusedErrorBorder: _border(context.colors.primary),
      ),
    );

    if (labelText?.isNotEmpty ?? false) {
      return Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            labelText!,
            style: context.titleSmallBold?.copyWith(
              fontSize: context.bodyMedium?.fontSize,
            ),
          ),
          field,
        ],
      );
    }

    return field;
  }
}
