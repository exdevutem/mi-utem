import "dart:convert";
import "dart:math";

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_markdown/flutter_markdown.dart";
import "package:get/get.dart";
import "package:mi_utem/models/user/user.dart";
import "package:mi_utem/services/remote_config/remote_config.dart";
import "package:mi_utem/services/review_service.dart";
import "package:mi_utem/services_new/interfaces/auth_service.dart";
import "package:mi_utem/services_new/interfaces/grades_service.dart";
import 'package:mi_utem/widgets/banners_section.dart';
import "package:mi_utem/widgets/custom_app_bar.dart";
import "package:mi_utem/widgets/custom_drawer.dart";
import "package:mi_utem/widgets/noticias/noticias_carrusel_widget.dart";
import "package:mi_utem/widgets/permisos_section.dart";
import "package:mi_utem/widgets/quick_menu_section.dart";
import "package:watch_it/watch_it.dart";

class MainScreen extends StatefulWidget {
  MainScreen({
    super.key,
  });

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  User? _user;
  final _authService = di.get<AuthService>();

  @override
  void initState() {
    super.initState();
    _authService.saveFCMToken();
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

    _authService.getUser().then((user) => setState(() => _user = user));
  }

  String get _greetingText {
    List<dynamic> texts = jsonDecode(RemoteConfigService.greetings);
    return texts[Random().nextInt(texts.length)].replaceAll("%name", _user?.primerNombre ?? "N/N");
  }

  @override
  Widget build(BuildContext context) {
    final banners = RemoteConfigService.banners;

    return Scaffold(
      appBar: CustomAppBar(title: Text("Inicio")),
      drawer: CustomDrawer(),
      floatingActionButton: kDebugMode ? FloatingActionButton(
        onPressed: () => di.get<GradesService>().lookForGradeUpdates(),
        tooltip: "Probar notificaciones de notas",
        child: Icon(Icons.notifications,
          color: Colors.white,
        ),
      ) : null,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            PermisosCovidSection(),
            const SizedBox(height: 20),
            QuickMenuSection(),
            const SizedBox(height: 20),
            if (banners.isNotEmpty) ...[
              BannersSection(banners: banners),
              const SizedBox(height: 20),
            ],
            NoticiasCarruselWidget(),
          ],
        ),
      ),
    );
  }
}
