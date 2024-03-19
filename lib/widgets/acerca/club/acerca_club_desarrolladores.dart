import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mi_utem/models/user/user.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:mi_utem/widgets/image_view_screen.dart';
import 'package:mi_utem/widgets/profile_photo.dart';
import 'package:url_launcher/url_launcher.dart';

class AcercaClubDesarrolladores extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text("Desarrolladores",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...jsonDecode(RemoteConfigService.miutemDesarrolladores).map((developer) => Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  ProfilePhoto(
                    user: User(nombres: developer['nombre'], fotoUrl: developer['fotoUrl']),
                    onImageTap: (context, imageProvider) {
                      AnalyticsService.logEvent("acerca_person_image_tap", parameters: {
                        "persona": developer['nombre'],
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => ImageViewScreen(imageProvider: imageProvider), fullscreenDialog: true));
                    },
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(developer["nombre"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                            fontSize: 16,
                          ),
                        ),
                        Text(developer["rol"],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: (developer['redes'] as List<dynamic>).map((socialNetwork) => Container(
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(socialNetwork["color"]),
                            ),
                            child: InkWell(
                              customBorder:
                              const CircleBorder(),
                              onTap: () async {
                                AnalyticsService.logEvent("acerca_person_social_tap",
                                  parameters: {
                                    "persona": developer['nombre'],
                                    "red": socialNetwork['nombre'],
                                  },
                                );
                                await launchUrl(Uri.parse(socialNetwork["url"]));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(shape: BoxShape.circle),
                                child: Icon(
                                  IconDataBrands(socialNetwork["icono"]),
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )).toList()
          ],
        ),
      ),
    );
  }
}