import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mi_utem/services/config_service.dart';

class AcercaAplicacionContent extends StatefulWidget {
  final String titulo;
  final String? preTitulo;

  AcercaAplicacionContent({this.titulo = "Aplicación", this.preTitulo});

  @override
  State<StatefulWidget> createState() => _AcercaAplicacionContentState();
}

class _AcercaAplicacionContentState extends State<AcercaAplicacionContent> {
  FirebaseRemoteConfig? _remoteConfig;

  @override
  void initState() {
    super.initState();
    _remoteConfig = ConfigService.config;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: _remoteConfig!.getString(ConfigService.MIUTEM_PORTADA),
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              if (widget.preTitulo != null && widget.preTitulo!.isNotEmpty)
                Text(
                  widget.preTitulo!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              if (widget.preTitulo != null && widget.preTitulo!.isNotEmpty)
                Container(height: 5),
              Text(
                widget.titulo,
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
                data: _remoteConfig!
                    .getString(
                      ConfigService.MIUTEM_DESCRIPCION,
                    )
                    .replaceAll(r"\n", "\n"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
