import 'dart:developer';

import 'package:eticon_api/eticon_api.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gg_copy/screens/comment_from_notifications_screen/comment_from_notifications_screen.dart';
import 'package:gg_copy/screens/comment_from_notifications_screen/comment_from_notifications_screen_provider.dart';
import 'package:gg_copy/screens/profile_screen/profile_screen_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'dart:io';
import 'presentation/app.dart';

void main() async {
  if (kDebugMode) {
    WidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = MyHttpOverrides();
    await Firebase.initializeApp();
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

    FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    String? a = await messaging.getToken();
    print("TOken : |${a}|");

    await Api.init(
        baseUrl: 'https://api.grustnogram.ru/',
        bearerToken: false,
        authTitle: 'Access-Token',
        globalTestMode: true);
    print(Api.token);
    runApp(App());
  } else {
    await SentryFlutter.init((options) {
      options.dsn =
          'https://99f002202b6a4e358eeafd55abf56666@o1192145.ingest.sentry.io/6313738';

      options.tracesSampleRate = 1.0;
    }, appRunner: () async {
      WidgetsFlutterBinding.ensureInitialized();
      HttpOverrides.global = MyHttpOverrides();
      await Firebase.initializeApp();
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

      FirebaseAnalytics analytics = FirebaseAnalytics.instance;

      String? a = await messaging.getToken();
      print("TOken : |${a}|");

      await Api.init(
          baseUrl: 'https://api.grustnogram.ru/',
          bearerToken: false,
          authTitle: 'Access-Token',
          globalTestMode: true);
      print(Api.token);
      runApp(App());
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
