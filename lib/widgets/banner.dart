import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:url_launcher/url_launcher.dart';

class IBanner {
  final String id;
  final String name;
  final Color backgroundColor;
  final String url;
  final String imageUrl;

  IBanner({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.url,
    required this.imageUrl,
  });

  factory IBanner.fromJson(Map<String, dynamic> json) {
    return IBanner(
      id: json["id"],
      name: json["name"],
      backgroundColor: HexColor(json["backgroundColor"]),
      url: json["url"],
      imageUrl: json["imageUrl"],
    );
  }

  static List<IBanner> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<IBanner> list = [];
    for (var item in json) {
      list.add(IBanner.fromJson(item));
    }
    return list;
  }
}

class MiUtemBanner extends StatelessWidget {
  final IBanner banner;

  const MiUtemBanner({
    Key? key,
    required this.banner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
  }

  void _onTap() async {
    AnalyticsService.logEvent(
      "banner_tap",
      parameters: {
        "banner_id": banner.id,
      },
    );
    await launchUrl(Uri.parse(banner.url));
  }
}
