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
import 'package:mi_utem/config/constants.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/config/router.dart';
import 'package:mi_utem/config/routes.dart';
import 'package:mi_utem/controllers/calculator_controller.dart';
import 'package:mi_utem/services/background_service.dart';
import 'package:mi_utem/services/config_service.dart';
import 'package:mi_utem/services/notification_service.dart';
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
  await NotificationService.initialize();
  await BackgroundService.initAndStart();
  await SentryFlutter.init(
    (options) {
      options.dsn = Constants.sentryDsn;
      options.attachScreenshot = true;
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MiUtem()),
  );
}

class MiUtem extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final calculatorController = Get.put(CalculatorController());

  @override
  Widget build(BuildContext context) {
    FlutterUxcam.optIntoSchematicRecordings();
    FlutterUxConfig config = FlutterUxConfig(
      userAppKey: kDebugMode ? Constants.uxCamDevKey : Constants.uxCamProdKey,
      enableAutomaticScreenNameTagging: true,
    );
    FlutterUxcam.startWithConfiguration(config);

    return GetMaterialApp(
      getPages: pages,
      initialRoute: Routes.splash,
      debugShowCheckedModeBanner: false,
      title: 'Mi UTEM',
      theme: MainTheme.theme,
      navigatorObservers: [
        FirebaseAnalyticsObserver(
          analytics: analytics,
          nameExtractor: (settings) {
            logger.d('Analytics: ${settings.name}');
            return settings.name;
          },
        ),
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
