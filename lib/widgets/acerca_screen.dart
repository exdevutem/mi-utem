import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/config_service.dart';
import 'package:mi_utem/widgets/acerca_aplicacion_content.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/default_network_image.dart';
import 'package:mi_utem/widgets/image_view_screen.dart';
import 'package:mi_utem/widgets/profile_photo.dart';
import 'package:url_launcher/url_launcher.dart';

class AcercaScreen extends StatefulWidget {
  AcercaScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AcercaScreenState();
}

class _AcercaScreenState extends State<AcercaScreen> {
  FirebaseRemoteConfig? _remoteConfig;

  @override
  void initState() {
    super.initState();
    _remoteConfig = ConfigService.config;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: CustomAppBar(
        title: Text(
          "Acerca de Mi UTEM",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
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
                            url: _remoteConfig!.getString(
                              ConfigService.CLUB_LOGO,
                            ),
                          )),
                      Container(height: 20),
                      Text(
                        _remoteConfig!.getString(
                          ConfigService.CLUB_NOMBRE,
                        ),
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
                        data: _remoteConfig!.getString(
                          ConfigService.CLUB_DESCRIPCION,
                        ),
                      ),
                      Container(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: jsonDecode(_remoteConfig!.getString(
                          ConfigService.CLUB_REDES,
                        ))
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
                                    FirebaseAnalytics.instance.logEvent(
                                      name: "acerca_club_social_click",
                                      parameters: {
                                        "red": red['nombre'],
                                      },
                                    );
                                    await launch(red["url"]);
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
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: AcercaAplicacionContent(),
              ),
              Card(
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
                      ...jsonDecode(_remoteConfig!.getString(
                        ConfigService.MIUTEM_DESARROLLADORES,
                      ))
                          .map<Widget>(
                            (creador) => Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  ProfilePhoto(
                                      usuario: Usuario(
                                          nombres: creador['nombre'],
                                          fotoUrl: creador['fotoUrl']),
                                      onImageTap: (context, imageProvider) {
                                        FirebaseAnalytics.instance.logEvent(
                                          name: "acerca_person_image_click",
                                          parameters: {
                                            "persona": creador['nombre'],
                                          },
                                        );
                                        Get.to(
                                          () => ImageViewScreen(
                                              imageProvider: imageProvider),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: creador['redes']
                                              .map<Widget>(
                                                (red) => Container(
                                                  margin:
                                                      EdgeInsets.only(right: 8),
                                                  decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(red["color"]),
                                                  ),
                                                  child: InkWell(
                                                    customBorder:
                                                        CircleBorder(),
                                                    onTap: () async {
                                                      FirebaseAnalytics.instance
                                                          .logEvent(
                                                        name:
                                                            "acerca_person_social_click",
                                                        parameters: {
                                                          "persona":
                                                              creador['nombre'],
                                                          "red": red['nombre'],
                                                        },
                                                      );
                                                      await launch(red["url"]);
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
                                                        IconDataBrands(
                                                            red["icono"]),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
