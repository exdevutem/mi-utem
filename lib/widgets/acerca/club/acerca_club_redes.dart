import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:url_launcher/url_launcher.dart';

class AcercaClubRedes extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: jsonDecode(RemoteConfigService.clubRedes)
            .map<Widget>(
              (red) => Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Color(red["color"]),
            ),
            child: InkWell(
              customBorder: CircleBorder(),
              onTap: () async {
                AnalyticsService.logEvent("acerca_club_social_tap",
                  parameters: {
                    "red": red['nombre'],
                  },
                );
                await launchUrl(Uri.parse(red["url"]));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  IconDataBrands(red["icono"]),
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ).toList()
    );
  }

}