import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  
  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: const Center(
        child: Column(
          children: [
            // Text('${message?.notification?.title}'),
            //  Text('${message.notification?.body}'),
              // Text(message.data),
          ],
        ),
      ),
    );
  }
}
