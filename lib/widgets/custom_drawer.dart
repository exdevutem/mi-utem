import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/screens/asignaturas_screen.dart';
import 'package:mi_utem/screens/credencial_screen.dart';
import 'package:mi_utem/screens/docentes_screen.dart';
import 'package:mi_utem/screens/horario_screen.dart';
import 'package:mi_utem/screens/login_screen.dart';
import 'package:mi_utem/screens/usuario_screen.dart';
import 'package:mi_utem/services/autenticacion_service.dart';
import 'package:mi_utem/services/config_service.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/acerca_screen.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/profile_photo.dart';

class CustomDrawer extends StatefulWidget {
  final Usuario usuario;
  CustomDrawer({Key? key, required this.usuario}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  RemoteConfig? _remoteConfig;

  @override
  void initState() {
    super.initState();
    _remoteConfig = ConfigService.config;
  }

  Widget? _getScreen(String? nombre) {
    switch (nombre) {
      case "Perfil":
        return UsuarioScreen();
        break;
      case "Asignaturas":
        return AsignaturasScreen();
        break;
      case "Horario":
        return HorarioScreen();
        break;
      case "Credencial":
        return CredencialScreen();
        break;
      case "Docentes":
        return DocentesScreen();
        break;
      default:
        return null;
    }
  }

  List? get _menu {
    return jsonDecode(_remoteConfig!.getString(ConfigService.DRAWER_MENU)).where((e) => e['mostrar'] == true).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: "Abrir menú",
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: constraints.copyWith(
              minHeight: constraints.maxHeight,
              maxHeight: double.infinity,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserAccountsDrawerHeader(
                    accountEmail: Text(widget.usuario.correo ?? ""),
                    accountName: Text(
                      widget.usuario.nombreCompleto ?? "",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    currentAccountPicture: ProfilePhoto(
                      usuario: widget.usuario,
                      radius: 30,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: <Color>[
                          MainTheme.utemAzul,
                          MainTheme.utemVerde,
                        ],
                      ),
                    ),
                  ),
                  for (var e in _menu!)
                    ListTile(
                      leading: Icon(IconData(e["icono"]["codePoint"], fontFamily: e["icono"]["fontFamily"], fontPackage: e["icono"]["fontPackage"])),
                      title: Text(e["nombre"]),
                       trailing: e["esNuevo"]
                          ? Badge(
                              shape: BadgeShape.square,
                              borderRadius: BorderRadius.circular(10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              elevation: 0,
                              badgeContent: Text(
                                'Nuevo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : null,
                      onTap: () async {
                        await Get.to(_getScreen(e["nombre"]));
                        ReviewService.checkAndRequestReview();
                      },
                    ),
                  Expanded(
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Divider(height: 5),
                          ListTile(
                            leading: Icon(Mdi.heart),
                            title: Text('Acerca de Mi UTEM'),
                            onTap: () async {
                              await Get.to(AcercaScreen());
                              ReviewService.checkAndRequestReview();
                            },
                          ),
                          ListTile(
                            leading: Icon(Mdi.closeCircle),
                            title: Text('Cerrar sesión'),
                            onTap: () async {
                              await AutenticacionService.logOut();

                              await Get.offAll(LoginScreen());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
