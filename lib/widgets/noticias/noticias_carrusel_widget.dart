import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/core/models/exceptions/custom_exception.dart';
import 'package:mi_utem/core/models/noticia.dart';
import 'package:mi_utem/core/services/noticias_service.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading/loading_indicator.dart';
import 'package:mi_utem/widgets/noticias/noticia_card_widget.dart';

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
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 10),
      FutureBuilder(
        future: Get.find<NoticiasService>().getNoticias(),
        builder: (context, AsyncSnapshot<List<Noticia>> snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error is CustomException ? (snapshot.error as CustomException) : CustomException.custom(message: "No pudimos obtener las noticias.");
            logger.d("[NoticiasCarruselWidget] ${error.message} (${error.statusCode})", snapshot.error, snapshot.stackTrace);

            return CustomErrorWidget(
              title: "Ocurrió un error al cargar las noticias",
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
              height: 230,
              viewportFraction: MediaQuery.of(context).orientation == Orientation.landscape ? 0.3 : 0.5,
              initialPage: 0,
            ),
            itemBuilder: (BuildContext context, int i, int rI) => NoticiaCardWidget(noticia: noticias[i]),
            itemCount: noticias.length,
          );
        },
      ),
    ],
  );
}
