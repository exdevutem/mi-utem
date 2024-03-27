import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mi_utem/config/constants.dart';
import 'package:mi_utem/config/http_clients.dart';
import 'package:mi_utem/screens/login_screen/login_screen.dart';
import 'package:mi_utem/screens/main_screen.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services/interfaces/auth_service.dart';
import 'package:mi_utem/services/notification_service.dart';
import 'package:mi_utem/widgets/loading_dialog.dart';
import 'package:mi_utem/widgets/snackbar.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  final _authService = Get.find<AuthService>();

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
    backgroundColor: Theme.of(context).primaryColor,
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
                      showLoadingDialog(context);
                      // Revisar si tenemos conexión a internet
                      try {
                        final response = await httpClient.get(Uri.parse(apiUrl));
                        final json = jsonDecode(response.body);
                        if(!(json is Map && json["funcionando"] == true)) {
                          Navigator.pop(context);
                          showTextSnackbar(context,
                            title: "Error",
                            message: "No se pudo conectar al servidor. Revisa tu conexión a internet.",
                            backgroundColor: Colors.red,
                          );
                          return;
                        }
                      } catch (e) {
                        Navigator.pop(context);
                        showTextSnackbar(context,
                          title: "Error",
                          message: "No se pudo conectar al servidor. Revisa tu conexión a internet.",
                          backgroundColor: Colors.red,
                        );
                        return;
                      }
                      await NotificationService.requestUserPermissionIfNecessary(context);
                      final isLoggedIn = await _authService.isLoggedIn();
                      if(!isLoggedIn) {
                        AnalyticsService.removeUser();
                      } else {
                        final user = await _authService.getUser();
                        if(user != null) {
                          AnalyticsService.setUser(user);
                        }
                      }
                      Navigator.popUntil(context, (route) => route.isFirst);
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
