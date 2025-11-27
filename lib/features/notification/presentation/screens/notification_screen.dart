import 'package:flutter/material.dart';
import 'package:vfxmoney/core/constants/app_colors.dart';
import 'package:vfxmoney/shared/widgets/app_text.dart';
import 'package:vfxmoney/shared/widgets/custom_appbar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(title: 'Notifications', implyLeading: true),
      body: const SafeArea(
        child: Column(
          children: [
            _NotificationFilterTabs(),
            Expanded(child: _NotificationList()),
          ],
        ),
      ),
    );
  }
}

/* ----------------------------------------------------------
 *  FILTER TABS
 * ---------------------------------------------------------- */
class _NotificationFilterTabs extends StatefulWidget {
  const _NotificationFilterTabs();

  @override
  State<_NotificationFilterTabs> createState() =>
      _NotificationFilterTabsState();
}

class _NotificationFilterTabsState extends State<_NotificationFilterTabs> {
  int _selectedIndex = 0;

  final List<String> _tabs = ['All', 'Unread', 'Transactions', 'Security'];

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color activeColor = Theme.of(context).primaryColor;
    final Color inactiveBackground = isDarkMode
        ? const Color(0xFF1A1A1A)
        : Colors.grey.shade200;
    final Color inactiveBorder = isDarkMode
        ? const Color(0xFF2A2A2A)
        : Colors.grey.shade400;
    final Color inactiveTextColor = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final bool isSelected = _selectedIndex == index;
            return Padding(
              padding: EdgeInsets.only(right: index < _tabs.length - 1 ? 8 : 0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? activeColor : inactiveBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected
                        ? null
                        : Border.all(color: inactiveBorder, width: 1),
                  ),
                  child: AppText(
                    _tabs[index],
                    fontSize: 12,
                    color: isSelected ? Colors.black : inactiveTextColor,
                    textStyle: 'jb',
                    w: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/* ----------------------------------------------------------
 *  NOTIFICATION LIST
 * ---------------------------------------------------------- */
class _NotificationList extends StatelessWidget {
  const _NotificationList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      itemCount: _dummyNotifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, index) =>
          _NotificationItem(notification: _dummyNotifications[index]),
    );
  }
}

/* ----------------------------------------------------------
 *  SINGLE NOTIFICATION ITEM
 * ---------------------------------------------------------- */
class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final Color textColor = Theme.of(context).colorScheme.onSurface;
    final Color secondaryTextColor = Theme.of(context).colorScheme.secondary;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: notification.type.backgroundColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification.type.icon,
                color: notification.type.iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppText(
                          notification.title,
                          fontSize: 14,
                          color: textColor,
                          textStyle: 'hb',
                          w: FontWeight.w600,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (notification.isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.greenVelvet,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    notification.message,
                    fontSize: 12,
                    color: secondaryTextColor,
                    textStyle: 'jb',
                    w: FontWeight.w400,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      AppText(
                        notification.time,
                        fontSize: 10,
                        color: secondaryTextColor,
                        textStyle: 'jb',
                        w: FontWeight.w400,
                      ),
                      const Spacer(),
                     
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ----------------------------------------------------------
 *  MODELS
 * ---------------------------------------------------------- */
enum NotificationType {
  transaction(Icons.account_balance_wallet_rounded, Color(0xFF4CAF50)),
  security(Icons.security_rounded, Color(0xFF2196F3)),
  promotion(Icons.local_offer_rounded, Color(0xFFFF9800)),
  system(Icons.notifications_rounded, Color(0xFF9C27B0));

  const NotificationType(this.icon, this.iconColor);
  final IconData icon;
  final Color iconColor;

  Color get backgroundColor => iconColor.withOpacity(0.1);
}

class NotificationModel {
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  final bool isUnread;
  final bool hasAction;

  const NotificationModel({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isUnread = false,
    this.hasAction = false,
  });
}

/* ----------------------------------------------------------
 *  DUMMY DATA
 * ---------------------------------------------------------- */
final List<NotificationModel> _dummyNotifications = [
  NotificationModel(
    title: 'Payment Successful',
    message:
        'Your payment of \$150.00 to John Smith was completed successfully',
    time: '2 min ago',
    type: NotificationType.transaction,
    isUnread: true,
    hasAction: true,
  ),
  NotificationModel(
    title: 'Security Alert',
    message:
        'New login detected from unknown device. Please verify your account.',
    time: '1 hour ago',
    type: NotificationType.security,
    isUnread: true,
    hasAction: true,
  ),
  NotificationModel(
    title: 'Weekly Promotion',
    message:
        'Get 20% cashback on all transactions this week. Limited time offer!',
    time: '3 hours ago',
    type: NotificationType.promotion,
    hasAction: true,
  ),
  NotificationModel(
    title: 'System Maintenance',
    message: 'Scheduled maintenance on Saturday 2:00 AM - 4:00 AM GMT',
    time: '1 day ago',
    type: NotificationType.system,
  ),
  NotificationModel(
    title: 'Money Received',
    message: 'You received \$75.00 from Sarah Johnson',
    time: '2 days ago',
    type: NotificationType.transaction,
    hasAction: true,
  ),
  NotificationModel(
    title: 'Password Changed',
    message: 'Your account password was successfully updated',
    time: '3 days ago',
    type: NotificationType.security,
  ),
  NotificationModel(
    title: 'Special Offer',
    message: 'Refer a friend and get \$10 bonus for both',
    time: '1 week ago',
    type: NotificationType.promotion,
    hasAction: true,
  ),
];
