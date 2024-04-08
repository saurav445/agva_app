// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'dart:async';
import 'package:agva_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessagingService {
  static String? fcmToken;

  static List<RemoteMessage> notifications = [];

  static final MessagingService _instance = MessagingService._internal();

  factory MessagingService() => _instance;

  MessagingService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final _messageController = StreamController<RemoteMessage>.broadcast();

  Stream<RemoteMessage> get messageStream => _messageController.stream;

  Future<void> init(BuildContext context) async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    debugPrint(
        'User granted notifications permission: ${settings.authorizationStatus}');

    // Handling background messages using the specified handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listening for incoming messages while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.notification!.title.toString()}');
      notifications.add(message);

      if (message.notification != null) {
        if (message.notification!.title != null &&
            message.notification!.body != null) {
          final notificationData = message.data;
          final screen = notificationData['screen'];

          flutterLocalNotificationsPlugin.show(
              message.notification!.hashCode,
              message.notification!.title,
              message.notification!.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelShowBadge: true,
                  icon: "@drawable/ic_launcher",
                ),
              ));
          if (notificationData['screen'] == '/usercontrol') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.notification!.title!,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 1,
                        child: Container(
                          color: Color.fromARGB(255, 181, 0, 100),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        message.notification!.body!,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.of(context).pushNamed(screen);
                            },
                            child: Text(
                              'View',
                              style: TextStyle(color: Colors.pink),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Dismiss',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          }
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
          'onMessageOpenedApp: ${message.notification!.title.toString()}');
      _handleNotificationClick(context, message);
      notifications.add(message);
      final notificationData = message.data;

      if (notificationData.containsKey('screen')) {
        final screen = notificationData['screen'];
        Navigator.of(context).pushNamed(screen);
      }
    });
    
_fcm.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(context, message);
        notifications.add(message);
        MessagingService.notifications.length;
      }
    });
  }

  void _handleNotificationClick(BuildContext context, RemoteMessage message) {
    final notificationData = message.data;
    notifications.add(message);
    if (notificationData.containsKey('screen')) {
      final screen = notificationData['screen'];
      Navigator.of(context).pushNamed(screen);
    }
  }

  // @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.

    notifications.add(message);
    print("Handling a background message: ${message.messageId}");
  }
}

// import 'dart:async';
// import 'package:agva_app/main.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class MessagingService {
//   static String? fcmToken;

//   static List<RemoteMessage> notifications = [];

//   static final MessagingService _instance = MessagingService._internal();

//   factory MessagingService() => _instance;

//   MessagingService._internal();

//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;

//   final _messageController = StreamController<RemoteMessage>.broadcast();

//   Stream<RemoteMessage> get messageStream => _messageController.stream;

//   Future<void> init(BuildContext context) async {
//     NotificationSettings settings = await _fcm.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );

//     debugPrint(
//         'User granted notifications permission: ${settings.authorizationStatus}');

//     // Handling background messages using the specified handler
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // Listening for incoming messages while the app is in the foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint('Got a message whilst in the foreground!');
//       debugPrint('Message data: ${message.notification!.title.toString()}');
//       notifications.add(message);
//       MessagingService.notifications.length;
//       _showNotification(message, context);
//       _handleNotificationClick(context, message);
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint(
//           'onMessageOpenedApp: ${message.notification!.title.toString()}');
//       _handleNotificationClick(context, message);
//       notifications.add(message);
//       MessagingService.notifications.length;
//       final notificationData = message.data;

//       if (notificationData.containsKey('screen')) {
//         final screen = notificationData['screen'];
//         Navigator.of(context).pushNamed(screen);
//       }
//     });

//     // Get the initial message if the app was opened from a terminated state
//     _fcm.getInitialMessage().then((message) {
//       if (message != null) {
//         _handleNotificationClick(context, message);
//         notifications.add(message);
//         MessagingService.notifications.length;
//       }
//     });
//   }

//   void _showNotification(RemoteMessage message, BuildContext context) {
//     if (message.notification != null) {
//       if (message.notification!.title != null &&
//           message.notification!.body != null) {
//         final notificationData = message.data;
//         final screen = notificationData['screen'];

//         flutterLocalNotificationsPlugin.show(
//             message.notification!.hashCode,
//             message.notification!.title,
//             message.notification!.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 channelShowBadge: true,
//                 icon: "@drawable/ic_launcher",
//               ),
//             ));
//         if (notificationData['screen'] == '/usercontrol') {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 backgroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       message.notification!.title!,
//                       style: TextStyle(
//                         color: const Color.fromARGB(255, 0, 0, 0),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     SizedBox(
//                       height: 1,
//                       child: Container(
//                         color: Color.fromARGB(255, 181, 0, 100),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       message.notification!.body!,
//                       style: TextStyle(
//                         color: const Color.fromARGB(255, 0, 0, 0),
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                             Navigator.of(context).pushNamed(screen);
//                           },
//                           child: Text(
//                             'View',
//                             style: TextStyle(color: Colors.pink),
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () => Navigator.of(context).pop(),
//                           child: Text(
//                             'Dismiss',
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             },
//           );
//         }
//       }
//     }
//   }

//   void _handleNotificationClick(BuildContext context, RemoteMessage message) {
//     final notificationData = message.data;
//     notifications.add(message);
//     if (notificationData.containsKey('screen')) {
//       final screen = notificationData['screen'];
//       Navigator.of(context).pushNamed(screen);
//     }
//   }

//   Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     notifications.add(message);
//     print("Handling a background message: ${message.messageId}");
//   }
// }
