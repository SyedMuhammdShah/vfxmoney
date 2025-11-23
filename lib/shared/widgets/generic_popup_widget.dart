import 'package:flutter/material.dart';
import 'package:vfxmoney/core/extensions/text_theme_extension.dart';
import 'package:vfxmoney/core/extensions/theme_extension.dart';

enum PopupType { singleAction, dualAction }

class GenericPopup extends StatefulWidget {
  final PopupType type;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final String title;
  final String? subtitle;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final String? passwordHint;
  final TextEditingController? passwordController;
  final bool obscurePassword;

  const GenericPopup({
    super.key,
    required this.type,
    this.icon,
    required this.title,
    this.iconColor = Colors.white,
    this.iconBackgroundColor = Colors.black,
    this.subtitle,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.passwordHint,
    this.passwordController,
    this.obscurePassword = true,
  });

  @override
  State<GenericPopup> createState() => _GenericPopupState();
}

class _GenericPopupState extends State<GenericPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Container
            widget.icon != null
                ? Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.iconBackgroundColor,
                    ),
                    child: Icon(widget.icon, color: widget.iconColor, size: 40),
                  )
                : const SizedBox.shrink(),

            // Title
            const SizedBox(height: 10),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            // Subtitle (if provided)
            if (widget.subtitle != null) ...[
              const SizedBox(height: 5),
              Text(
                widget.subtitle!,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
                textAlign: TextAlign.start,
              ),
            ],

            const SizedBox(height: 10),

            // Buttons based on type
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    switch (widget.type) {
      case PopupType.singleAction:
        return _buildSingleButton(context);
      case PopupType.dualAction:
        return _buildDualButtons(context);
    }
  }

  Widget _buildSingleButton(BuildContext context) {
    if (widget.primaryButtonText == null || widget.primaryButtonText!.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.onPrimaryPressed ?? () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          widget.primaryButtonText!,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDualButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed:
              widget.onSecondaryPressed ?? () => Navigator.of(context).pop(),
          child: Text(
            widget.secondaryButtonText ?? "Cancel",
            style: context.bodySemiBoldMedium,
          ),
        ),
        TextButton(
          onPressed:
              widget.onPrimaryPressed ?? () => Navigator.of(context).pop(),
          child: Text(
            widget.primaryButtonText ?? "Yes",
            style: context.bodySemiBoldMedium?.copyWith(
              color: context.colors.error,
            ),
          ),
        ),
      ],
    );
  }
}

// Extension for easy usage
extension PopupUtils on BuildContext {
  // Show success popup
  void showSuccessPopup({
    required String title,
    String? subtitle,
    IconData? icon,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: this,
      builder: (context) => GenericPopup(
        type: PopupType.singleAction,
        icon: icon,
        title: title,
        subtitle: subtitle,
        primaryButtonText: buttonText,
        onPrimaryPressed: buttonText != null ? onPressed : null,
      ),
    );
  }

  // Show confirmation popup
  void showConfirmationPopup({
    required String title,
    String? subtitle,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String? confirmText,
    String? cancelText,
    IconData? icon,
  }) {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (dialogContext) {
        return GenericPopup(
          type: PopupType.dualAction,
          icon: icon,
          title: title,
          subtitle: subtitle,
          primaryButtonText: confirmText,
          secondaryButtonText: cancelText,
          onPrimaryPressed: () {
            Navigator.of(dialogContext).pop();
            onConfirm();
          },
          onSecondaryPressed: () {
            Navigator.of(dialogContext).pop();
            if (onCancel != null) onCancel();
          },
        );
      },
    );
  }
}
