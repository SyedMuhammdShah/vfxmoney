import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';
import '../../core/extensions/text_theme_extension.dart';

class CustomLoader {
  static final CustomLoader _instance = CustomLoader._internal();
  factory CustomLoader() => _instance;
  CustomLoader._internal();

  OverlayEntry? _overlayEntry;
  OverlayState? _overlayState;
  VoidCallback? _popCallbackRemover;

  /// Show loader with optional message
  void show(BuildContext context, {String message = "Please wait..."}) {
    if (_overlayEntry != null) return;

    _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      maintainState: true,
      builder: (_) => _buildLoader(context, message: message),
    );

    // Block back button press
    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      Future<bool> callback() async => false;
      modalRoute.addScopedWillPopCallback(callback);
      _popCallbackRemover = () =>
          modalRoute.removeScopedWillPopCallback(callback);
    }

    _overlayState?.insert(_overlayEntry!);
  }

  /// Hide loader safely
  void hide() {
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _popCallbackRemover?.call();
      _popCallbackRemover = null;
    } catch (e) {
      debugPrint("Error hiding loader: $e");
    }
  }

  Widget _buildLoader(BuildContext context, {required String message}) {
    final Color backgroundColor = const Color(0xffa8a8a8).withAlpha(127);

    return Stack(
      alignment: Alignment.center,
      children: [
        ModalBarrier(dismissible: false, color: backgroundColor),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.tealShade,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: context.bodyMedium?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
