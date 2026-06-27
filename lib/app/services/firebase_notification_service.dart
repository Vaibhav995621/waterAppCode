import 'dart:developer' as developer;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  developer.log("Handling a background message: ${message.messageId}");
}

// Android Notification Channel definition for heads-up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FirebaseNotificationService {
  static final FirebaseNotificationService instance = FirebaseNotificationService._internal();
  FirebaseNotificationService._internal();

  Future<void> initialize() async {
    try {
      // 1. Initialize Firebase
      await Firebase.initializeApp();

      // 2. Set the background messaging handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // 3. Configure local notifications for foreground display
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );

      await flutterLocalNotificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          developer.log("Local notification clicked: ${response.payload}");
        },
      );

      // 4. Create Android high-importance notification channel
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(channel);
      }

      // 5. Set presentation options for foreground notifications on iOS
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // 6. Request permissions (especially required for iOS)
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      developer.log('User granted permission: ${settings.authorizationStatus}');

      // 7. Retrieve & Print FCM Token (same token for Android & iOS)
      String? token = await messaging.getToken();
      developer.log("=========================================");
      developer.log("🔥 FIREBASE FCM TOKEN 🔥");
      developer.log("$token");
      developer.log("=========================================");
      
      // Also print to console
      print("🔥 FCM Token: $token");

      // 8. Handle foreground notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        developer.log('Got a message whilst in the foreground!');
        developer.log('Message data: ${message.data}');

        RemoteNotification? notification = message.notification;

        if (notification != null) {
          flutterLocalNotificationsPlugin.show(
            id: notification.hashCode,
            title: notification.title,
            body: notification.body,
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_launcher',
                importance: Importance.max,
                priority: Priority.high,
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
          );
        }
      });

      // 9. Handle notification click when app is in background but still running
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        developer.log('Notification clicked!');
      });

      // 10. Check if app was opened from a terminated state via a notification
      RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        developer.log('App opened from terminated state via notification');
      }

      // 11. Listen to token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        developer.log("FCM Token Refreshed: $newToken");
        print("🔥 FCM Token Refreshed: $newToken");
      });

    } catch (e) {
      developer.log("Error initializing Firebase Notifications: $e");
    }
  }
}
