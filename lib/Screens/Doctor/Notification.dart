import 'package:firebase_messaging/firebase_messaging.dart';
class Notfication {
  final fbm = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await fbm.requestPermission();
    final fbToken = await fbm.getToken();
    print('Token ${fbToken}');
  }
}