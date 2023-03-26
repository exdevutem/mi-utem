import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:flutter_uxcam/flutter_uxcam_observer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/screens/splash_screen.dart';
import 'package:mi_utem/services/config_service.dart';
import 'package:mi_utem/services/notificaciones_service.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await GetStorage.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await ConfigService.getInstance();
  await NotificationsService.initialize();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://0af59b2ad2b44f4e8c9cad4ea8d5f32e@o507661.ingest.sentry.io/5599080';
      options.attachScreenshot = true;
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MiUtem()),
  );
}

class MiUtem extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    final uxCamProd = "fxkjj5ulr7vb4yf";
    final uxCamDev = "0y6p88obpgiug1g";

    FlutterUxcam.optIntoSchematicRecordings();
    FlutterUxConfig config = FlutterUxConfig(
      userAppKey: kDebugMode ? uxCamDev : uxCamProd,
      enableAutomaticScreenNameTagging: true,
    );
    FlutterUxcam.startWithConfiguration(config);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi UTEM',
      theme: MainTheme.theme,
      home: SplashScreen(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
        SentryNavigatorObserver(),
        FlutterUxcamNavigatorObserver()
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
