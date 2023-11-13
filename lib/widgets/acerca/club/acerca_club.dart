import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../services/remote_config/remote_config.dart';
import '../../default_network_image.dart';
import 'acerca_club_redes.dart';

class AcercaClub extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
                width: 150,
                height: 150,
                child: DefaultNetworkImage(
                  url: RemoteConfigService.clubLogo,
                )),
            Container(height: 20),
            Text(
              RemoteConfigService.clubNombre,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(height: 20),
            MarkdownBody(
              selectable: false,
              styleSheet: MarkdownStyleSheet(
                textAlign: WrapAlignment.center,
                p: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              data: RemoteConfigService.clubDescripcion,
            ),
            Container(height: 20),
            AcercaClubRedes(),
          ],
        ),
      ),
    );
  }
}