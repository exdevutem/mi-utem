import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/core/models/novedades/ibanner.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MiUtemBanner extends StatelessWidget {
  final IBanner banner;

  const MiUtemBanner({
    super.key,
    required this.banner,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Container(
      width: constraints.maxWidth,
      height: constraints.maxWidth * 0.4,
      child: InkWell(
        onTap: _onTap,
        child: Card(
          margin: EdgeInsets.zero,
          color: banner.backgroundColor,
          borderOnForeground: false,
          child: CachedNetworkImage(
            imageUrl: banner.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );

  void _onTap() async {
    AnalyticsService.logEvent("banner_tap", parameters: {
      "banner_id": banner.id,
    });
    await launchUrl(Uri.parse(banner.url));
  }
}
