import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/routes.dart';
import '../../../models/usuario.dart';
import '../../../services/analytics_service.dart';
import '../../../services/remote_config/remote_config.dart';
import '../../image_view_screen.dart';
import '../../profile_photo.dart';

class AcercaClubDesarrolladores extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Desarrolladores",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(height: 10),
            ...jsonDecode(RemoteConfigService.miutemDesarrolladores).map<Widget>((creador) => Container (
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  ProfilePhoto(
                      usuario: Usuario(nombres: creador['nombre'], fotoUrl: creador['fotoUrl']),
                      onImageTap: (context, imageProvider) {
                        AnalyticsService.logEvent("acerca_person_image_tap", parameters: {
                          "persona": creador['nombre'],
                        });
                        Get.to(() => ImageViewScreen(imageProvider: imageProvider),
                          routeName: Routes.imageView,
                        );
                      }),
                  Container(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          creador["nombre"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          creador["rol"],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        Container(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: creador['redes'].map<Widget>((red) => Container(
                            margin: EdgeInsets.only(right: 8),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(red["color"]),
                            ),
                            child: InkWell(
                              customBorder:
                              CircleBorder(),
                              onTap: () async {
                                AnalyticsService.logEvent("acerca_person_social_tap",
                                  parameters: {
                                    "persona":
                                    creador['nombre'],
                                    "red": red['nombre'],
                                  },
                                );
                                await launchUrl(
                                  Uri.parse(red["url"]),
                                );
                              },
                              child: Container(
                                padding:
                                const EdgeInsets.all(
                                    8),
                                decoration:
                                new BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  IconDataBrands(red["icono"]),
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            )
                .toList()
          ],
        ),
      ),
    );
  }
}