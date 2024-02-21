// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final message =
        ModalRoute.of(context)!.settings.arguments as RemoteMessage?;
    final title = message?.notification?.title ?? 'No Title';
    final body = message?.notification?.body ?? 'No Body';
    final data = message?.data ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Title: $title'),
            Text('Body: $body'),
            if (data.isNotEmpty) ...[
              SizedBox(height: 20),
              Text('Additional Data:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              for (var entry in data.entries) ...[
                Text('${entry.key}: ${entry.value}'),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
