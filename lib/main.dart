import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/core/utils/constants.dart';
import 'package:mi_utem/screens/splash_screen.dart';
import 'package:mi_utem/service_manager.dart';
import 'package:mi_utem/services/background_service.dart';
import 'package:mi_utem/services/notification_service.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'services/remote_config/remote_config.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await GetStorage.init();
  await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  await Firebase.initializeApp();
  await RemoteConfigService.initialize();
  await registerServices();
  await NotificationService.initialize();
  await BackgroundService.initAndStart();
  await SentryFlutter.init((options) {
    options.dsn = sentryDsn;
    options.attachScreenshot = true;
    options.tracesSampleRate = 1.0;
    options.enableMetrics = true;
    options.attachViewHierarchy = true;
  }, appRunner: () => runApp(SentryWidget(child: MiUtem())));
}

class MiUtem extends StatefulWidget {
  @override
  State<MiUtem> createState() => _MiUtemState();
}

class _MiUtemState extends State<MiUtem> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    FlutterUxcam.optIntoSchematicRecordings();
    FlutterUxcam.startWithConfiguration(FlutterUxConfig(
      userAppKey: kDebugMode ? uxCamDevKey : uxCamProdKey,
      enableAutomaticScreenNameTagging: true,
      enableMultiSessionRecord: true,
    ));

    return GetMaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      title: 'Mi UTEM',
      theme: MainTheme.theme,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
        SentryNavigatorObserver(),
        FlutterUxcamNavigatorObserver()
      ],
      defaultTransition: Transition.native,
    );
  }
}
