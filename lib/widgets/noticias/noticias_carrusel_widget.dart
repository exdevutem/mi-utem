import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/models/noticia.dart';
import 'package:mi_utem/services_new/interfaces/noticias_service.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/noticias/noticia_card_widget.dart';
import 'package:watch_it/watch_it.dart';

class NoticiasCarruselWidget extends StatelessWidget {

  const NoticiasCarruselWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text("Noticias".toUpperCase(),
          style: Get.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 10),
      FutureBuilder(
        future: di.get<NoticiasService>().getNoticias(),
        builder: (context, AsyncSnapshot<List<Noticia>?> snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error is CustomException ? (snapshot.error as CustomException) : CustomException.custom("No pudimos obtener las noticias.");

            return CustomErrorWidget(
              title: "Ocurrió un error al obtener las noticias",
              error: error.message,
            );
          }

          List<Noticia>? noticias = snapshot.data;

          if(!snapshot.hasData || noticias == null || noticias.isEmpty) {
            return Center(child: LoadingIndicator());
          }

          return CarouselSlider.builder(
            options: CarouselOptions(
              autoPlay: true,
              height: 200,
              viewportFraction: MediaQuery.of(context).orientation == Orientation.landscape ? 0.3 : 0.5,
              initialPage: 0,
            ),
            itemBuilder: (BuildContext context, int i, int rI) => NoticiaCardWidget(noticias[i]),
            itemCount: noticias.length,
          );
        },
      ),
    ],
  );
}
