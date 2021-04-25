import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mi_utem/screens/splash_screen.dart';
import 'package:mi_utem/services/config_service.dart';
import 'package:mi_utem/services/notificaciones_service.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:sentry_flutter/sentry_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await ConfigService.getInstance();
  await NotificationsService.initialize();
  await Sentry.init(
    (options) {
      options.dsn = 'https://0af59b2ad2b44f4e8c9cad4ea8d5f32e@o507661.ingest.sentry.io/5599080';
    },
    appRunner: () => runApp(MiUtem()),
  );
}

class MiUtem extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi UTEM',
      theme: MainTheme.theme,
      home: SplashScreen(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}
