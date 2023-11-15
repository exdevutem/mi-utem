import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';

class AcercaAplicacionContent extends StatelessWidget {
  final String titulo;
  final String? preTitulo;

  AcercaAplicacionContent({this.titulo = "Aplicación", this.preTitulo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: RemoteConfigService.miutemPortada,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              if (preTitulo != null && preTitulo!.isNotEmpty)
                Text(
                  preTitulo!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              if (preTitulo != null && preTitulo!.isNotEmpty)
                Container(height: 5),
              Text(
                titulo,
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
                data: RemoteConfigService.miutemDescripcion
                    .replaceAll(r"\n", "\n"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
