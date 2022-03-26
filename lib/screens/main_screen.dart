import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/screens/asignaturas_screen.dart';
import 'package:mi_utem/screens/horario_screen.dart';
import 'package:mi_utem/services/config_service.dart';
import 'package:mi_utem/services/perfil_service.dart';
import 'package:mi_utem/services/review_service.dart';
//import 'package:new_version/new_version.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_drawer.dart';
import 'package:mi_utem/widgets/noticias_carrusel.dart';

class MainScreen extends StatefulWidget {
  final Usuario usuario;
  MainScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _a = 0;

  FirebaseRemoteConfig? _remoteConfig;

  @override
  void initState() {
    super.initState();
    _remoteConfig = ConfigService.config;
    PerfilService.saveFcmToken();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    FirebaseAnalytics.instance.logEvent(name: "home");

    ReviewService.addScreen("MainScreen");
    ReviewService.checkAndRequestReview();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _checkAndPerformUpdate(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkAndPerformUpdate(BuildContext context) async {
    try {
      /* VersionStatus status = await NewVersion(context: context).getVersionStatus();
      print("status.localVersion ${status.localVersion}");
      print("status.storeVersion ${status.storeVersion}");

      var localVersion = status.localVersion.split(".");
      var storeVersion = status.storeVersion.split(".");
      if (storeVersion[0].compareTo(localVersion[0]) > 0) {
        if (Platform.isAndroid) {
          AppUpdateInfo info = await InAppUpdate.checkForUpdate();

          if (info.updateAvailable == true) {
            await InAppUpdate.performImmediateUpdate();
          }
        }
      } else if (storeVersion[1].compareTo(localVersion[1]) > 0) {
        if (Platform.isAndroid) {
          AppUpdateInfo info = await InAppUpdate.checkForUpdate();
          
          if (info.updateAvailable == true) {
            await InAppUpdate.startFlexibleUpdate();
            await InAppUpdate.completeFlexibleUpdate();
          }
        }
      } else if (storeVersion[2].compareTo(localVersion[2]) > 0) {
        print("MINOR");
      }
 */
      return;
    } catch (error) {
      print("_checkAndPerformUpdate Error: ${error.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Inicio"),
      ),
      drawer: CustomDrawer(usuario: widget.usuario),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GradientCard(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      gradient: Gradients.cosmicFusion,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.to(AsignaturasScreen());
                          },
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Container(
                            padding: EdgeInsets.all(30),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.book,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                Container(height: 10),
                                Text(
                                  "Notas",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GradientCard(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      gradient: Gradients.hotLinear,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.to(HorarioScreen());
                          },
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Container(
                            padding: EdgeInsets.all(30),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Icon(
                                  Mdi.clockTimeEight,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                Container(height: 10),
                                Text(
                                  "Horario",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 20),
            Text(
              "Noticias".toUpperCase(),
              style: Theme.of(context).textTheme.headline4,
            ),
            Container(height: 10),
            NoticiasCarrusel(),
            Container(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  _a = _a + 1;
                });
                if (_a >= 11) {
                  _a = 0;
                  if (_remoteConfig!.getBool(ConfigService.EG_HABILITADOS)) {
                    Get.snackbar(
                      "Error",
                      _remoteConfig!.getString(ConfigService.PRONTO_EG),
                      colorText: Colors.white,
                      backgroundColor: Get.theme.primaryColor,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: EdgeInsets.all(20),
                    );
                    FirebaseAnalytics.instance.logEvent(name: "pronto_eg");
                  }
                }
              },
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      IconData(
                          _remoteConfig!
                              .getInt(ConfigService.HOME_PRONTO_ICONO),
                          fontFamily: 'MaterialIcons'),
                      size: 150,
                      color: Colors.grey,
                    ),
                    Container(
                      height: 20,
                    ),
                    Text(
                      _remoteConfig!.getString(ConfigService.HOME_PRONTO_TEXTO),
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
