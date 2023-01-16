
import 'dart:collection';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../modules/others/services/others_service.dart';

void initFirebaseMessaging() async {
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

  var authBox = Hive.box('authBox');
  if (authBox.get("accessToken", defaultValue: "") == "" ||
      authBox.get("refreshToken", defaultValue: "") == "") {
    return;
  }

  String? token;
  if (kIsWeb) {
    token = await messaging.getToken(
      vapidKey:
      "BIgHP7EqgpZXidJsM7wBfTzSgprBDxTK_3FZYju4oP5ggJLUWo2gna-KGDTWgIicbpuoA9VxvLtXZN0sDhrf2XA",
    );
  } else {
    token = await messaging.getToken();
  }

  if (token != null) {
    if (authBox.get("FCMTOKEN", defaultValue: "") == "" ||
        authBox.get("FCMTOKEN", defaultValue: "") != token) {
      HashMap<String, dynamic> hashMap = HashMap();
      hashMap["fcmToken"] = token;
      String? response = await OthersService().addRegistrationToken(hashMap);
      if (response != null) {
        authBox.put("FCMTOKEN", token);
      }
    }
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // debugPrint('Got a message whilst in the foreground!');
    // debugPrint('Message data: ${message.data}');
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'arpan_main',
      'Arpan Main Notification',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (message.notification != null) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: 'ic_arpan_icon_notification',
              ),
            ));
      }
    }
  });
}
