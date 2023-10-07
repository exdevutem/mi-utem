import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mi_utem/services/analytics_service.dart';

class InnovaUtemBanner extends StatefulWidget {
  const InnovaUtemBanner({Key? key}) : super(key: key);

  @override
  State<InnovaUtemBanner> createState() => _InnovaUtemBanner();
}

class _InnovaUtemBanner extends State<InnovaUtemBanner> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            "Novedades".toUpperCase(),
            style: Get.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(height: 10),
        Container(
          width: 350,
          height: 175,
          child: Card(
              color: Color(0xFF72147D),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () async {
                  AnalyticsService.logEvent(
                    "innova_utem_banner_tap",
                  );
                  await launchUrl(
                      Uri.parse("https://innova.utem.cl/emprende-utem/"));
                },
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Image.network(
                        "https://innova.utem.cl/wp-content/uploads/2023/08/1.png",
                        width: 350,
                        height: 175,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 0,
                      child: Image.network(
                        "https://innova.utem.cl/wp-content/uploads/2023/08/2-e1692572336685.png",
                        fit: BoxFit.cover,
                        scale: 3.5,
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      left: 60,
                      // ROunded button with text 'Ver Más'
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFB600),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        child: Text(
                          "Ver Más",
                          style: Get.textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        )
      ],
    );
  }
}
