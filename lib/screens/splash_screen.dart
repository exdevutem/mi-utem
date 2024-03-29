import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mi_utem/config/routes.dart';
import 'package:mi_utem/services/notification_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var delayed;

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

  bool _terminoAnimacion = false;

  void _onEndAnimacion() async {
    _terminoAnimacion = true;
    _cambiarPantalla();
  }

  void _cambiarPantalla() async {
    if (_terminoAnimacion) {
      Get.offAllNamed(
        Routes.home,
      );
      await NotificationService.requestUserPermissionIfNecessary();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: Stack(
        children: <Widget>[
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
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Hero(
                    tag: 'utemLogo',
                    child: FlareActor(
                      "assets/animations/utem.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: "default",
                      callback: (String val) {
                        _onEndAnimacion();
                      },
                    ),
                  ),
                ),
              ),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  if (!snapshot.hasError &&
                      snapshot.hasData &&
                      snapshot.data != null) {
                    PackageInfo packageInfo = snapshot.data!;
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Versión: ${packageInfo.version}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
