import 'package:flutter/material.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';

class ProfileHeader extends StatelessWidget {
  final String imagePath;
  final String name;
  final String email;

  const ProfileHeader({
    super.key,
    required this.imagePath,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).colorScheme.onSurface;
    final Color secondaryTextColor = Theme.of(context).colorScheme.secondary;

    return Column(
      children: [
        /// Circular Image
        CircleAvatar(
          radius: 48,
          backgroundImage: NetworkImage(imagePath),
        ),

        const SizedBox(height: 16),

        /// Name
        AppText(
          name,
          textStyle: 'hb',
          fontSize: 20,
          w: FontWeight.w700,
          color: textColor,
        ),

        const SizedBox(height: 4),

        /// Email
        AppText(
          email,
          textStyle: 'jb',
          fontSize: 12,
          color: secondaryTextColor,
        ),
      ],
    );
  }
}