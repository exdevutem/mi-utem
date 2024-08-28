import "dart:convert";
import "dart:math";

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_markdown/flutter_markdown.dart";
import "package:get/get.dart";
import "package:mi_utem/controllers/grades/grade_update_handler.dart";
import "package:mi_utem/core/models/novedades/ibanner.dart";
import 'package:mi_utem/core/models/preferencia.dart';
import "package:mi_utem/core/models/user/estudiante.dart";
import "package:mi_utem/core/services/auth_service.dart";
import 'package:mi_utem/core/services/noticias_service.dart';
import "package:mi_utem/core/services/permisos_service.dart";
import "package:mi_utem/services/remote_config/remote_config.dart";
import "package:mi_utem/services/review_service.dart";
import "package:mi_utem/widgets/custom_app_bar.dart";
import "package:mi_utem/widgets/custom_drawer.dart";
import "package:mi_utem/widgets/main_screen/novedades/banners_section.dart";
import "package:mi_utem/widgets/main_screen/permisos/permisos_section.dart";
import "package:mi_utem/widgets/noticias/noticias_carrusel_widget.dart";
import "package:mi_utem/widgets/pull_to_refresh.dart";
import 'package:mi_utem/widgets/quick_access/quick_menu_section.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List<IBanner> _banners = const [];
  Estudiante? _user;
  final _authService = Get.find<AuthService>();

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
    ReviewService.checkAndRequestReview(context);

    loadData(forceRefresh: false);

    _authService.login().then((user) => setState(() => _user = user));
  }

  Future<void> loadData({ bool forceRefresh = true }) async {
    if(forceRefresh) {
      await RemoteConfigService.update();
    }
    await Get.find<PermisosService>().getPermisos(forceRefresh: forceRefresh); // Forzar re-descarga de los permisos
    await Get.find<NoticiasService>().getNoticias(forceRefresh: forceRefresh); // Forzar re-descarga de las noticias
    setState(() => _banners = RemoteConfigService.banners); // Actualizar los banners y se re-renderiza
  }

  String get _greetingText {
    List<dynamic> texts = jsonDecode(RemoteConfigService.greetings);
    return texts[Random().nextInt(texts.length)];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppBar(title: Text("Inicio")),
    drawer: CustomDrawer(),
    floatingActionButton: kDebugMode ? FloatingActionButton(
      onPressed: () => Get.find<GradeUpdateHandler>().lookForGradeUpdates(),
      tooltip: "Probar notificaciones de notas",
      child: Icon(Icons.notifications,
        color: Colors.white,
      ),
    ) : null,
    body: PullToRefresh(
      onRefresh: loadData,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: FutureBuilder<String?>(
                    future: Preferencia.apodo.get(defaultValue: "N/N"),
                    initialData: _user?.primerNombre ?? "N/N",
                    builder: (ctx, snapshot) => MarkdownBody(
                      data: _greetingText.replaceAll("%name", snapshot.data ?? "N/N"),
                      styleSheet: MarkdownStyleSheet(
                        p: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              PermisosCovidSection(),
              const SizedBox(height: 20),
              const QuickMenuSection(),
              const SizedBox(height: 20),
              if (_banners.isNotEmpty) ...[
                BannersSection(banners: _banners),
                const SizedBox(height: 20),
              ],
              NoticiasCarruselWidget(),
            ],
          ),
        ),
      ),
    ),
  );
}
