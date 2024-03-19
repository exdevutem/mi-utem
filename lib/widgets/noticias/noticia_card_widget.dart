import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/models/noticia.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticiaCardWidget extends StatefulWidget {

  final Noticia _noticia;

  NoticiaCardWidget(this._noticia);

  @override
  State<NoticiaCardWidget> createState() => _NoticiaCardWidgetState();
}

class _NoticiaCardWidgetState extends State<NoticiaCardWidget> {

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 200,
    width: 200,
    child: Card(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            AnalyticsService.logEvent("noticia_card_tap");
            this._launchURL(widget._noticia.link!);
          },
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              widget._noticia.imagen != null ? Image.network(widget._noticia.imagen!, height: 110, fit: BoxFit.cover) : Container(
                height: 110,
                width: double.infinity,
                color: Colors.grey,
                child: Icon(
                  Mdi.imageOff,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Spacer(),
                    Text(
                      widget._noticia.titulo!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Get.theme.textTheme.bodyLarge,
                    ),
                    Spacer(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
