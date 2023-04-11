import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/noticia.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services/noticias_service.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/noticia_card.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticiasSection extends StatefulWidget {
  NoticiasSection({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NoticiasSectionState();
}

class _NoticiasSectionState extends State<NoticiasSection> {
  Future<List<Noticia>>? _noticiasFuture;

  @override
  void initState() {
    super.initState();
    _noticiasFuture = _getNoticias();
  }

  Future<List<Noticia>> _getNoticias() async {
    List<Noticia> noticias = await NoticiasService.getNoticias();
    return noticias;
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Noticias".toUpperCase(),
            style: Get.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(height: 10),
        FutureBuilder<List<Noticia>>(
          future: _noticiasFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return CustomErrorWidget(
                  title: "Ocurrió un error al obtener las noticias",
                  error: snapshot.error);
            } else {
              if (snapshot.hasData && snapshot.data!.length > 0) {
                List<Noticia> noticias = snapshot.data!;
                return CarouselSlider.builder(
                  options: CarouselOptions(
                    autoPlay: true,
                    height: 200,
                    viewportFraction: 0.5,
                    initialPage: 0,
                  ),
                  itemBuilder: (BuildContext context, int i, int rI) =>
                      NoticiaCard(
                    titulo: noticias[i].titulo,
                    subtitulo: noticias[i].subtitulo,
                    imagenUrl: noticias[i].featuredMedia?.guid,
                    onTap: () {
                      AnalyticsService.logEvent("noticia_tap");
                      _launchURL(noticias[i].link!);
                    },
                  ),
                  itemCount: noticias.length,
                );
              } else {
                return Center(child: LoadingIndicator());
              }
            }
          },
        ),
      ],
    );
  }
}
