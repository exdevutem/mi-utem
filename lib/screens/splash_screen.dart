import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/screens/login_screen.dart';
import 'package:mi_utem/screens/main_screen.dart';
import 'package:mi_utem/services/autenticacion_service.dart';
import 'package:mi_utem/services/notificaciones_service.dart';
import 'package:mi_utem/services/perfil_service.dart';
import 'package:package_info/package_info.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var delayed;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics().setCurrentScreen(screenName: 'SplashScreen');

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    _validarToken();
  }

  Future<void> onActionSelected(String value) async {
    switch (value) {
      case 'subscribe':
        {
          print(
              'FlutterFire Messaging Example: Subscribing to topic "fcm_test".');
          await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
          print(
              'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.');
        }
        break;
      case 'unsubscribe':
        {
          print(
              'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".');
          await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
          print(
              'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.');
        }
        break;
      case 'get_apns_token':
        {
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS) {
            print('FlutterFire Messaging Example: Getting APNs token...');
            String token = await FirebaseMessaging.instance.getAPNSToken();
            print('FlutterFire Messaging Example: Got APNs token: $token');
          } else {
            print(
                'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.');
          }
        }
        break;
      default:
        break;
    }
  }

  bool _terminoAnimacion = false;
  Widget _ruta;

  void _onEndAnimacion() async {
    _terminoAnimacion = true;
    _cambiarPantalla();
  }

  void _validarToken() async {
    try {
      bool isLoggedIn = await AutenticacionService.isLoggedIn();
      if (isLoggedIn) {
        Usuario usuario = await PerfilService.getLocalUsuario();
        _ruta = MainScreen(usuario: usuario);
      } else {
        _ruta = LoginScreen();
      }
    } catch (e) {
      _ruta = LoginScreen();
    }

    _cambiarPantalla();
  }

  void _cambiarPantalla() async {
    print("_cambiarPantalla $_ruta $_terminoAnimacion");
    if (_terminoAnimacion && _ruta != null) {
      Get.offAll(_ruta);
      await NotificationsService.requestUserPermissionIfNecessary();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
              FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  if (!snapshot.hasError && snapshot.hasData) {
                    PackageInfo packageInfo = snapshot.data;
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
