import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/core/models/noticia.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/widgets/loading/loading_indicator.dart';
import 'package:mi_utem/widgets/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticiaCardWidget extends StatelessWidget {

  final Noticia noticia;

  const NoticiaCardWidget({
    required this.noticia,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 230,
    width: 250,
    child: Card(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onTapNoticia(context),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedNetworkImage(
                imageUrl: noticia.imagen,
                placeholder: (ctx, url) => LoadingIndicator(),
                errorWidget: (ctx, url, error) => Icon(Icons.error, size: 110, color: Theme.of(context).colorScheme.error),
                height: 110,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Text(noticia.titulo,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  _onTapNoticia(BuildContext context) async {
    final url = noticia.link;
    if (await canLaunchUrl(Uri.parse(url))) {
      AnalyticsService.logEvent("noticia_card_tap");
      await launchUrl(Uri.parse(url));
    } else {
      showErrorSnackbar(context, "No se pudo abrir la noticia. Intenta más tarde.");
    }
  }
}
