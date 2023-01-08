import "dart:convert";
import "dart:math";

import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter/services.dart";

import "package:firebase_analytics/firebase_analytics.dart";
import "package:firebase_remote_config/firebase_remote_config.dart";
import "package:flutter_markdown/flutter_markdown.dart";
import "package:get/get.dart";

import "package:mi_utem/models/usuario.dart";
import "package:mi_utem/services/config_service.dart";
import "package:mi_utem/services/perfil_service.dart";
import "package:mi_utem/services/review_service.dart";
import "package:mi_utem/widgets/custom_app_bar.dart";
import "package:mi_utem/widgets/custom_drawer.dart";
import "package:mi_utem/widgets/noticias_carrusel.dart";
import "package:mi_utem/widgets/permisos_section.dart";
import "package:mi_utem/widgets/quick_menu_section.dart";
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/services/permisos_covid_service.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';

class MainScreen extends StatefulWidget {
  final Usuario usuario;
  MainScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late FirebaseRemoteConfig? _remoteConfig;
  //late Future<List<PermisoCovid>> _permisosFuture;
  List<PermisoCovid>? _permisos;
  int _a = 0;

  @override
  void initState() {
    super.initState();
    _remoteConfig = ConfigService.config;
    //_permisosFuture = _getPermisos();
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
      _checkAndPerformUpdate();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<PermisoCovid>> _getPermisos([bool refresh = false]) async {
    List<PermisoCovid> permisos =
        await PermisosCovidService.getPermisos(refresh);
    setState(() {
      _permisos = permisos;
    });
    return permisos;
  }

  Future<void> _onRefresh() async {
    await _getPermisos(true);
  }

  Future<void> _checkAndPerformUpdate() async {
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

  String get _greetingText {
    List<dynamic> texts = jsonDecode(_remoteConfig!.getString(
      ConfigService.GREETINGS,
    ));

    Random random = new Random();
    String text = texts[random.nextInt(texts.length)];
    text = text.replaceAll("%name", widget.usuario.primerNombre);
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Inicio"),
      ),
      drawer: CustomDrawer(usuario: widget.usuario),
      body: PullToRefresh(
        onRefresh: () async {
          await _onRefresh();
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: MarkdownBody(
                  data: _greetingText,
                  styleSheet: MarkdownStyleSheet(
                    p: Get.textTheme.headline2!
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              Container(height: 20),
              PermisosCovidSection(permisos: _permisos),
              Container(height: 20),
              QuickMenuSection(),
              Container(height: 20),
              NoticiasSection(),
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
                            fontFamily: "MaterialIcons"),
                        size: 150,
                        color: Colors.grey,
                      ),
                      Container(
                        height: 20,
                      ),
                      Text(
                        _remoteConfig!
                            .getString(ConfigService.HOME_PRONTO_TEXTO),
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
