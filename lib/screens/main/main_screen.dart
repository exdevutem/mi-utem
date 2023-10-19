import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:mi_utem/controllers/grades_changes_controller.dart';
import "package:mi_utem/screens/main/widgets/greetings.dart";
import "package:mi_utem/services/perfil_service.dart";
import "package:mi_utem/services/remote_config/remote_config.dart";
import "package:mi_utem/services/review_service.dart";
import 'package:mi_utem/widgets/banners_section.dart';
import "package:mi_utem/widgets/custom_app_bar.dart";
import "package:mi_utem/widgets/custom_drawer.dart";
import "package:mi_utem/widgets/noticias_carrusel.dart";
import "package:mi_utem/widgets/permisos_section.dart";
import "package:mi_utem/widgets/quick_menu_section.dart";

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final banners = RemoteConfigService.banners;

    return Scaffold(
      appBar: CustomAppBar(title: Text("Inicio")),
      drawer: CustomDrawer(),
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
            MainScreenGreetings(),
            Container(height: 20),
            PermisosCovidSection(),
            Container(height: 20),
            QuickMenuSection(),
            Container(height: 20),
            if (banners.isNotEmpty) ...[
              BannersSection(
                banners: banners,
              ),
              Container(height: 20),
            ],
            NoticiasSection(),
          ],
        ),
      ),
    );
  }
}
