import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/noticia.dart';
import 'package:mi_utem/services/noticias_service.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/noticias/NoticiaCardWidget.dart';

class NoticiasCarruselWidget extends StatefulWidget {
  NoticiasCarruselWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NoticiasCarruselWidgetState();
}

class _NoticiasCarruselWidgetState extends State<NoticiasCarruselWidget> {
  Future<List<Noticia>>? _noticiasFuture;

  @override
  void initState() {
    super.initState();
    _noticiasFuture = _getNoticias();
  }

  Future<List<Noticia>> _getNoticias() async => await NoticiasService().getNoticias();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text("Noticias".toUpperCase(),
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
              return CustomErrorWidget(title: "Ocurrió un error al obtener las noticias", error: snapshot.error);
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
                  itemBuilder: (BuildContext context, int i, int rI) => NoticiaCardWidget(noticias[i]),
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
