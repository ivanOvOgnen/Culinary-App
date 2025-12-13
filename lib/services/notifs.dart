// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    if (!kIsWeb) {
      print('Notifications only supported on web');
      return;
    }

    try {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('Notification permission granted');

        String? token = await _firebaseMessaging.getToken(
          vapidKey:dotenv.env['FIREBASE_VAPID_KEY'],
        );
        print('FCM Web Token: $token');

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          print('Foreground message: ${message.notification?.title}');
          
          _showBrowserNotification(
            message.notification?.title ?? 'New Recipe!',
            message.notification?.body ?? 'Check out today\'s recipe',
          );
        });

        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      } else {
        print('Notification permission denied');
      }
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  void _showBrowserNotification(String title, String body) {
    if (kIsWeb) {
      html.Notification.requestPermission().then((permission) {
        if (permission == 'granted') {
          html.Notification(
            title,
            body: body,
            icon: '/icons/Icon-192.png', 
          );
        }
      });
    }
  }

  Future<void> scheduleDailyRecipeNotification(String userId) async {
    print('User $userId registered for daily notifications');
  }

  Future<void> cancelAllNotifications() async {
    await _firebaseMessaging.deleteToken();
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message: ${message.notification?.title}');
}