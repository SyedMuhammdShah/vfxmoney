// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import '../navigation/app_router.dart';

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();

//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   late final NotificationBloc bloc;

//   NotificationService._internal();

//   factory NotificationService({NotificationBloc? bloc}) {
//     if (bloc != null) _instance.bloc = bloc;
//     return _instance;
//   }

//   Future<void> initialize() async {
//     await _requestPermissions();
//     await _setupLocalNotifications();
//     await _registerFirebaseListeners();

//     final token = await getFcmToken();
//     log("FCM token: $token");
//   }

//   Future<void> _requestPermissions() async {
//     final settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     log('Notification permission: ${settings.authorizationStatus}');

//     await _messaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }

//   Future<void> _setupLocalNotifications() async {
//     const androidSettings = AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );
//     const iosSettings = DarwinInitializationSettings();

//     final settings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );

//     await _localNotificationsPlugin.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         if (response.payload != null) {
//           try {
//             print(response.payload.runtimeType);
//             final data = jsonDecode(response.payload!);
//             _handleNotificationTap(data);
//           } catch (e) {
//             log('Failed to parse payload: $e');
//           }
//         }
//       },
//     );
//   }

//   Future<void> _registerFirebaseListeners() async {
//     // Foreground
//     FirebaseMessaging.onMessage.listen((message) {
//       log("📨 Foreground notification: ${message.notification?.title}");
//       if (Platform.isAndroid) {
//         _showLocalNotification(message);
//       }
//       bloc.add(ToggleHasNew(true));
//     });

//     // Background
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       log("📲 Tapped notification (background): ${message.data}");
//       _handleNotificationTap(message.data);
//     });

//     // Terminated
//     final initialMessage = await _messaging.getInitialMessage();
//     if (initialMessage != null) {
//       log("💤 Tapped notification (terminated): ${initialMessage.data}");
//       _handleNotificationTap(initialMessage.data);
//     }
//   }

//   Future<void> _showLocalNotification(RemoteMessage message) async {
//     final androidDetails = AndroidNotificationDetails(
//       'high_importance_channel',
//       'High Importance Notifications',
//       channelDescription: 'DropIn Channel for Push Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//     );

//     final details = NotificationDetails(
//       android: androidDetails,
//       iOS: const DarwinNotificationDetails(),
//     );

//     await _localNotificationsPlugin.show(
//       message.notification.hashCode,
//       message.notification?.title ?? 'DropIn Notification',
//       message.notification?.body ?? '',
//       details,
//       payload: jsonEncode(message.data),
//     );
//   }

//   void _handleNotificationTap(Map<String, dynamic> data) {
//     final context = AppRouter.router.routerDelegate.navigatorKey.currentContext;

//     if (context == null) {
//       log('[NOTIFICATION] ❌ Context is null — retrying...');
//       Future.delayed(const Duration(milliseconds: 300), () {
//         _handleNotificationTap(data);
//       });
//       return;
//     }
//     final type = data['type'];
//     final chatroomID = data['chatroomID'];
//     final isGroup = ((data['isChatGroup'] as String?) ?? '').contains('true');
//     final eventID = data['eventID'];
//     final groupID = data['groupID'];
//     final userID = data['userID'];

//     Future.delayed(const Duration(milliseconds: 300), () {
//       switch (type) {
//         case 'chats':
//           if (chatroomID?.isNotEmpty ?? false) {
//             AppRouter.router.pushNamed(
//               Routes.chat.name,
//               extra: {
//                 'chatroom': chatroomID,
//                 'isGroupChat': isGroup == true ? 'group' : 'chat',
//               },
//             );
//           }
//           break;
//         case 'events':
//           if (eventID?.isNotEmpty ?? false) {
//             AppRouter.router.pushNamed(
//               Routes.eventDetails.name,
//               extra: {'eventID': eventID},
//             );
//           }
//           break;
//         case 'groups':
//           if (groupID?.isNotEmpty ?? false) {
//             AppRouter.router.pushNamed(
//               Routes.groupProfileScreen.name,
//               extra: {'groupID': groupID},
//             );
//           }
//           break;
//         case 'connections':
//           if (userID?.isNotEmpty ?? false) {
//             AppRouter.router.pushNamed(
//               Routes.myConnectionProfile.name,
//               extra: {'hostId': userID},
//             );
//           }
//           break;
//         case 'badges':
//           if (userID?.isNotEmpty ?? false) {
//             AppRouter.router.pushNamed(Routes.myBadgesScreen.name);
//           }
//           break;
//         default:
//           log('⚠️ Unknown notification type: $type');
//       }
//     });
//   }

//   Future<String?> getFcmToken() => _messaging.getToken();
// }
