import 'package:flutter/material.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';

class AppInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool obscureText;
  final String? Function(String?) validator;
  final VoidCallback? onToggleObscure;

  const AppInputField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleObscure,
  }) : super(key: key);

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  final ValueNotifier<String?> errorNotifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.bgGreyColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,

            validator: (value) {
              final errorText = widget.validator(value);

              WidgetsBinding.instance.addPostFrameCallback((_) {
                errorNotifier.value = errorText;
              });

              return null;
            },

            autovalidateMode: AutovalidateMode.onUserInteraction,

            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 14,
              color: Colors.white,
            ),

            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              hintStyle: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 14,
                color: AppColors.greytextColor,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        widget.obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.greytextColor,
                        size: 20,
                      ),
                      onPressed: widget.onToggleObscure,
                    )
                  : null,
            ),

            onChanged: (_) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                errorNotifier.value = null;
              });
            },
          ),
        ),

        ValueListenableBuilder<String?>(
          valueListenable: errorNotifier,
          builder: (_, error, __) {
            if (error == null) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(top: 4, left: 16),
              child: AppText(
                error,
                fontSize: 11,
                color: Colors.redAccent,
                textStyle: 'jb',
              ),
            );
          },
        ),
      ],
    );
  }
}
