import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print(' fcm token : $fCMToken');
  }

  initializeApp() {}
}