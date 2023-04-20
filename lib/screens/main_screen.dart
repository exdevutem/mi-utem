import "dart:convert";
import "dart:math";

import "package:firebase_remote_config/firebase_remote_config.dart";
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_markdown/flutter_markdown.dart";
import "package:get/get.dart";
import 'package:mi_utem/controllers/grades_changes_controller.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import "package:mi_utem/models/usuario.dart";
import 'package:mi_utem/services/analytics_service.dart';
import "package:mi_utem/services/config_service.dart";
import "package:mi_utem/services/perfil_service.dart";
import "package:mi_utem/services/review_service.dart";
import "package:mi_utem/widgets/custom_app_bar.dart";
import "package:mi_utem/widgets/custom_drawer.dart";
import "package:mi_utem/widgets/noticias_carrusel.dart";
import "package:mi_utem/widgets/permisos_section.dart";
import "package:mi_utem/widgets/quick_menu_section.dart";

class MainScreen extends StatefulWidget {
  final Usuario usuario;
  MainScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late FirebaseRemoteConfig? _remoteConfig;
  List<PermisoCovid>? _permisos;
  int _a = 0;

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

    ReviewService.addScreen("MainScreen");
    ReviewService.checkAndRequestReview();
  }

  @override
  void dispose() {
    super.dispose();
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
      appBar: CustomAppBar(title: Text("Inicio")),
      drawer: CustomDrawer(usuario: widget.usuario),
      floatingActionButton: kDebugMode
          ? FloatingActionButton(
              onPressed: () {
                GradesChangesController.checkIfGradesHasChange();
              },
              tooltip: "Probar notificaciones de notas",
              child: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
            )
          : null,
      body: SingleChildScrollView(
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
                  p: Get.textTheme.displayMedium!
                      .copyWith(fontWeight: FontWeight.normal),
                ),
              ),
            ),
            Container(height: 20),
            PermisosCovidSection(),
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
                    AnalyticsService.logEvent("show_pronto_eg");
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
