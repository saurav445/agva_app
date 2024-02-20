// ignore_for_file: unused_import, prefer_const_constructors

// import 'package:agva_app/Screens/NotificationScreen.dart';
// import 'package:agva_app/main.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   print("Title : ${message.notification?.title}");
//   print("Body : ${message.notification?.body}");
//   print("Payload : ${message.data}");
// }

// void handleMessage(RemoteMessage? message) {
//   if(message ==  null) return;
// navigatorKey.currentState?.pushNamed("/notification", arguments: message);
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
// }

// class FirebaseService {
//   final _firebaseMessaging = FirebaseMessaging.instance;
//   Future<void> initNotifications() async {
//     await _firebaseMessaging.requestPermission();
//     final fCMToken = await _firebaseMessaging.getToken();
//     print(' FCM Token : $fCMToken');
//     initPushNotifications();
//   }
//   initializeApp() {}
// }

import 'dart:convert';
import 'package:agva_app/Screens/NotificationScreen.dart';
import 'package:agva_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title : ${message.notification?.title}");
  print("Body : ${message.notification?.body}");
  print("Payload : ${message.data}");
}

void handleMessage(RemoteMessage? message) {
  if (message == null) return;
  navigatorKey.currentState?.pushNamed("/notification", arguments: message);
}

Future<void> initLocalNotification() async {
  const AndroidInitializationSettings android = AndroidInitializationSettings('@drawable/ic_launcher');
  const InitializationSettings settings = InitializationSettings(android: android);

  await _localNotifications.initialize(
    settings,
    // onDidReceiveNotificationResponse: 
    
    // onSelectNotification: 
    //(String? payload) async {
    //   if (payload != null) {
    //     final message = RemoteMessage.fromMap(jsonDecode(payload));
    //     handleMessage(message); 
    //   }
    // },
  );
  
  final platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  
  await platform?.createNotificationChannel(AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for receiving alert notifications',
    importance: Importance.defaultImportance,
  ));
}

Future initPushNotifications() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  FirebaseMessaging.onMessage.listen((message) {
    if (message == null) return;

    _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for receiving alert notifications',
          importance: Importance.defaultImportance,
          icon: '@drawable/ic_launcher',
        ),
      ),
      payload: jsonEncode(message.data),
    );
  });
}

class FirebaseService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('FCM Token : $fCMToken');
    initPushNotifications();
    initLocalNotification();
  }

  initializeApp() {}
}