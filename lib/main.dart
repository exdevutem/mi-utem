import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mi_utem/screens/splash_screen.dart';
import 'package:mi_utem/services/config_service.dart';
import 'package:mi_utem/services/notificaciones_service.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sentry/sentry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await ConfigService.getInstance();
  await NotificationsService.initialize();
  await Sentry.init(
    (options) {
      options.dsn =
          'https://0af59b2ad2b44f4e8c9cad4ea8d5f32e@o507661.ingest.sentry.io/5599080';
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
      builder: (context, widget) => ResponsiveWrapper.builder(
        widget,
        maxWidth: 1200,
        minWidth: 360,
        breakpoints: [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(2460, name: '4K'),
        ],
      ),
    );
  }
}
