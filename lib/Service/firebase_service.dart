// import 'dart:convert';
// import 'package:agva_app/Screens/NotificationScreen.dart';
// import 'package:agva_app/main.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   print("Title : ${message.notification?.title}");
//   print("Body : ${message.notification?.body}");
//   print("Payload : ${message.data}");
// }

// void handleMessage(RemoteMessage? message) {
//   if (message == null) return;
//   navigatorKey.currentState?.pushNamed("/notification", arguments: message);
// }

// Future<void> initLocalNotification() async {
//   const AndroidInitializationSettings android = AndroidInitializationSettings('@drawable/ic_launcher');
//   const InitializationSettings settings = InitializationSettings(android: android);

//   await _localNotifications.initialize(
//     settings,
//     // onDidReceiveNotificationResponse:

//     // onSelectNotification:
//     //(String? payload) async {
//     //   if (payload != null) {
//     //     final message = RemoteMessage.fromMap(jsonDecode(payload));
//     //     handleMessage(message);
//     //   }
//     // },
//   );

//   final platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

//   await platform?.createNotificationChannel(AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: 'This channel is used for receiving alert notifications',
//     importance: Importance.defaultImportance,
//   ));
// }

// Future initPushNotifications() async {
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//   FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//   FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//   FirebaseMessaging.onMessage.listen((message) {
//     if (message == null) return;

//     _localNotifications.show(
//       message.hashCode,
//       message.notification?.title,
//       message.notification?.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           'high_importance_channel',
//           'High Importance Notifications',
//           channelDescription: 'This channel is used for receiving alert notifications',
//           importance: Importance.defaultImportance,
//           icon: '@drawable/ic_launcher',
//         ),
//       ),
//       payload: jsonEncode(message.data),
//     );
//   });
// }

// class FirebaseService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   Future<void> initNotifications() async {
//     await _firebaseMessaging.requestPermission();
//     final fCMToken = await _firebaseMessaging.getToken();
//     print('FCM Token : $fCMToken');
//     initPushNotifications();
//     initLocalNotification();
//   }

//   initializeApp() {}
// }

// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:agva_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Initialize FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin _localNotifications =
    FlutterLocalNotificationsPlugin();

// Function to handle background messages
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title : ${message.notification?.title}");
  print("Body : ${message.notification?.body}");
  print("Payload : ${message.data}");
}

// Function to handle incoming messages
void handleMessage(RemoteMessage? message) {
  if (message != null) return; 
  navigatorKey.currentState?.pushNamed("/notification", arguments: message);
 
}

// Function to initialize local notifications
Future<void> initLocalNotification() async {
  // Initialize Android settings
  const AndroidInitializationSettings android =
      AndroidInitializationSettings('@drawable/ic_launcher');
  const InitializationSettings settings =
      InitializationSettings(android: android);

  // Initialize FlutterLocalNotificationsPlugin
  await _localNotifications.initialize(
    settings,
    // You can handle notification taps here if needed
  );

  // Create notification channel
  final platform = _localNotifications.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  await platform?.createNotificationChannel(AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for receiving alert notifications',
    importance: Importance.defaultImportance,
  ));
}

// Function to initialize push notifications
Future<void> initPushNotifications() async {
  // Set notification presentation options for foreground messages
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Handle initial message if the app is opened via notification tap
  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

  // Listen for incoming messages when the app is in the foreground
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

  // Listen for background messages
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  // Listen for incoming messages
  FirebaseMessaging.onMessage.listen((message) {
    if (message == null) return;
    // Show local notification when a message is received
    _localNotifications.show(
      message.hashCode, // Unique ID for the notification
      message.notification?.title, // Notification title
      message.notification?.body, // Notification body
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', // Channel ID
          'High Importance Notifications', // Channel name
          channelDescription:
              'This channel is used for receiving alert notifications', // Channel description
          importance: Importance.defaultImportance,
          icon: '@drawable/ic_launcher', // Icon for the notification
        ),
      ),
      payload: jsonEncode(message.data), // Optional payload
    );
  });
}

// Class to manage Firebase services
class FirebaseService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Initialize Firebase notifications
  Future<void> initNotifications() async {
    // Request permission for notifications
    await _firebaseMessaging.requestPermission();
    // Get FCM token
    final fCMToken = await _firebaseMessaging.getToken();
    print('FCM Token : $fCMToken');
    // Initialize push notifications
    initPushNotifications();
    // Initialize local notifications
    initLocalNotification();
  }

  // Initialize the app
  initializeApp() {
    // You can add app initialization code here if needed
  }
}
