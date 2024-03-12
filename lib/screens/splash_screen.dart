import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/screens/login_screen/login_screen.dart';
import 'package:mi_utem/screens/main_screen.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services/notification_service.dart';
import 'package:mi_utem/services_new/interfaces/auth_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:watch_it/watch_it.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  final _authService = di.get<AuthService>();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Get.theme.primaryColor,
    body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xff1d8e5c), Color(0xff06607a)],
            ),
          ),
        ),
        Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Hero(
                  tag: 'utemLogo',
                  child: FlareActor("assets/animations/utem.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: "default",
                    callback: (String val) async {
                      await NotificationService.requestUserPermissionIfNecessary();
                      final isLoggedIn = await _authService.isLoggedIn();
                      if(!isLoggedIn) {
                        AnalyticsService.removeUser();
                      } else {
                        final user = await _authService.getUser();
                        if(user != null) {
                          AnalyticsService.setUser(user);
                        }
                      }
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => isLoggedIn ? MainScreen() : LoginScreen()));
                    },
                  ),
                ),
              ),
            ),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) => !snapshot.hasError && snapshot.hasData && snapshot.data != null ? Padding(
                padding: const EdgeInsets.all(10),
                child: Text("Versión: ${snapshot.data?.version}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ) : Container(),
            ),
          ],
        ),
      ],
    ),
  );
}
