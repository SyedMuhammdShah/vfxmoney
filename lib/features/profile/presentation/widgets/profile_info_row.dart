import 'package:flutter/material.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';
import '../../../../core/constants/app_colors.dart';

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final Color labelColor = Theme.of(context).colorScheme.secondary;
    final Color valueColor = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            label,
            textStyle: 'jb',
            fontSize: 13,
            color: labelColor,
          ),
          AppText(
            value,
            textStyle: 'jb',
            fontSize: 13,
            color: valueColor,
          ),
        ],
      ),
    );
  }
}