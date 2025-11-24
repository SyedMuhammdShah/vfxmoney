import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vfxmoney/core/navigation/route_enums.dart';
import 'app_text.dart'; // Import your AppText widget

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool implyLeading;
  final List<Widget>? actions;
  final bool showProfileHeader;
  final String userName;
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;

  const CustomAppBar({
    super.key,
    required this.title,
    this.implyLeading = false,
    this.actions,
    this.showProfileHeader = false,
    this.userName = '',
    this.avatarUrl,
    this.onAvatarTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Theme-based colors
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color textColor = Theme.of(context).colorScheme.onSurface;
    final Color secondaryTextColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final Color iconColor = Theme.of(context).colorScheme.onSurface;
    final Color borderColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200;
    final Color avatarBackgroundColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;

    /* ----------  default right-side icons  ---------- */
    List<Widget> defaultActions() => [
      IconButton(
        icon: Icon(Icons.settings_outlined, color: iconColor),
        onPressed: () => context.pushNamed(Routes.settings.name),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.notifications_none, color: iconColor),
              onPressed: () {
                /* TODO notifications */
              },
            ),
            Positioned(
              top: 10,
              right: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, // Green Velvet
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    if (showProfileHeader) {
      return AppBar(
        automaticallyImplyLeading: implyLeading,
        elevation: 0,
        backgroundColor: backgroundColor,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              GestureDetector(
                onTap: onAvatarTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 1),
                    image: avatarUrl != null
                        ? DecorationImage(
                            image: NetworkImage(avatarUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: avatarUrl == null ? avatarBackgroundColor : null,
                  ),
                  child: avatarUrl == null
                      ? Icon(Icons.person, color: isDarkMode ? Colors.grey.shade300 : Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    'Welcome Back',
                    color: secondaryTextColor,
                    fontSize: 14,
                    w: FontWeight.w400,
                    textStyle: 'hb', // Using HubotSans
                  ),
                  AppText(
                    userName,
                    color: textColor,
                    fontSize: 18,
                    w: FontWeight.w600,
                    textStyle: 'hb', // Using HubotSans
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: actions ?? defaultActions(),
      );
    }

    return AppBar(
      automaticallyImplyLeading: implyLeading,
      elevation: 0,
      backgroundColor: backgroundColor,
      title: AppText(
        title,
        color: textColor,
        fontSize: 20,
        w: FontWeight.w600,
        textStyle: 'hb', // Using HubotSans for titles
      ),
      centerTitle: true,
      actions: actions ?? defaultActions(),
    );
  }
}