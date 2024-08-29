import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class CredencialRear extends StatelessWidget {
  const CredencialRear({super.key});

  @override
  Widget build(BuildContext context) => Card(
    elevation: 1,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    margin: EdgeInsets.all(20),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [MainTheme.utemAzul, MainTheme.utemVerde],
            ),
          ),
          height: 20,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              "Credencial compatible con",
                              style: TextStyle(
                                  color: MainTheme.grey, fontSize: 12),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Text(
                              "Sistema de Bibliotecas",
                              style: TextStyle(
                                color: MainTheme.primaryDarkColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Text(
                              "SIBUTEM",
                              style: TextStyle(
                                color: MainTheme.primaryDarkColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 20),
                    CachedNetworkImage(
                      imageUrl: RemoteConfigService.credencialSibutemLogo,
                      height: 70,
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: MainTheme.primaryDarkColor,
                    ),
                  ),
                  padding: EdgeInsets.all(15),
                  child: MarkdownBody(
                    selectable: false,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        color: MainTheme.primaryDarkColor,
                      ),
                    ),
                    data: RemoteConfigService.credencialDisclaimer,
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: MarkdownBody(
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        color: MainTheme.primaryDarkColor,
                        fontSize: 15,
                      ),
                      a: TextStyle(
                        color: MainTheme.primaryDarkColor,
                      ),
                    ),
                    onTapLink: (text, href, title) => launchUrl(Uri.parse(href!)),
                    data: RemoteConfigService.credencialInfo.replaceAll(r"\n", "\n"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
