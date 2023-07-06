import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// void handleMessage(RemoteMessage? Message) {
//   if (Message == null) return;
// }

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  //print('Title' + message.notification!.title!);
  //print('Body' + message.notification!.body!);
  //print('Payload' + message.data.toString());
} // This is the function that will be called when a notification is received whilst the app is in the background

void saveToken(String token, String uid) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).update({
    'token': token,
  });
}

class firebaseApi {
  final _firebasemessaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future initLocalNotification() async {
    const iOS = IOSInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
    await _flutterLocalNotificationsPlugin.initialize(settings,
        onSelectNotification: (payload) async {
      if (payload != null) {
        final message = RemoteMessage.fromMap(jsonDecode(payload));

        //handleMessage(message);
      }
    });
    final platform =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // FirebaseMessaging.onMessage.listen((message) {
    //   handleMessage(message);
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   handleMessage(message);
    // });
    //FirebaseMessaging.instance.getInitialMessage().then((handleMessage));
    FirebaseMessaging.onBackgroundMessage((handleBackgroundMessage));
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future<void> initNotification() async {
    NotificationSettings settings = await _firebasemessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final token = await _firebasemessaging.getToken();
    // print('Token: $token');
    // final uid = FirebaseAuth.instance.currentUser!.uid;
    // saveToken(token!, uid);
    initPushNotifications();
    initLocalNotification();
  }
}
