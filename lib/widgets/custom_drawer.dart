import 'dart:developer';

import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/config/routes/routes.dart';
import 'package:mi_utem/controllers/user_controller.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/profile_photo.dart';

class IDrawerItem {
  final String title;
  final IconData icon;
  final String route;
  final List<Role> requiredRoles;
  final bool show;
  final String? badge;

  IDrawerItem({
    required this.title,
    required this.icon,
    required this.route,
    this.requiredRoles = const [],
    this.show = true,
    this.badge,
  });

  factory IDrawerItem.fromJson(Map<String, dynamic> json) {
    final roles = <Role>[];
    if (json['requiredRoles'] != null) {
      for (String roleString in json['requiredRoles']) {
        final role = RoleExtension.fromName(roleString);
        if (role != null) {
          roles.add(role);
        }
      }
    }

    return IDrawerItem(
      title: json['title'],
      icon: IconData(
        json['icon']['codePoint'],
        fontFamily: json['icon']['fontFamily'],
        fontPackage: json['icon']['fontPackage'],
      ),
      route: json['route'],
      badge: json['badge'],
      show: json['show'] ?? true,
      requiredRoles: roles,
    );
  }

  static List<IDrawerItem> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<IDrawerItem> list = [];
    for (var item in json) {
      list.add(IDrawerItem.fromJson(item));
    }
    return list;
  }
}

List<IDrawerItem> _filteredMenu =
    RemoteConfigService.drawerMenu.where((e) => e.show).toList();

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key}) : super(key: key);

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
                  Obx(() {
                    final user = UserController.to.user.value;
                    return UserAccountsDrawerHeader(
                      accountEmail: Text(user?.correoUtem ??
                          user?.correoPersonal ??
                          "Sin correo"),
                      accountName: Text(
                        user?.nombreCompleto ?? "Sin nombre",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      currentAccountPicture: ProfilePhoto(
                        usuario: user,
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
                    );
                  }),
                  for (var e in _filteredMenu)
                    Obx(
                      () => CustomDrawerItem(
                        item: e,
                        currentUserRoles: UserController.to.roles,
                      ),
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
                              await Get.toNamed(Routes.about);
                              ReviewService.checkAndRequestReview();
                            },
                          ),
                          ListTile(
                            leading: Icon(Mdi.closeCircle),
                            title: Text('Cerrar sesión'),
                            onTap: () async {
                              await UserController.to.logOut();

                              await Get.offAllNamed(Routes.home);
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

class CustomDrawerItem extends StatelessWidget {
  const CustomDrawerItem({
    Key? key,
    required this.item,
    required this.currentUserRoles,
  }) : super(key: key);

  final IDrawerItem item;
  final List<Role> currentUserRoles;

  @override
  Widget build(BuildContext context) {
    final currentUserRolesSet = currentUserRoles.toSet();

    log("CustomDrawerItem: ${item.title} requiredRoles ${item.requiredRoles} currentUserRoles $currentUserRoles");

    if (item.requiredRoles.isNotEmpty &&
        !currentUserRolesSet.containsAll(item.requiredRoles)) {
      return Container();
    }

    return ListTile(
      leading: Icon(item.icon),
      title: Text(item.title),
      trailing: item.badge != null
          ? badge.Badge(
              shape: badge.BadgeShape.square,
              borderRadius: BorderRadius.circular(10),
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              elevation: 0,
              badgeContent: Text(
                item.badge!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: () async {
        Get.toNamed(item.route);
        ReviewService.checkAndRequestReview();
      },
    );
  }
}
