import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:mi_utem/widgets/banner.dart';

class BannersSection extends StatefulWidget {
  const BannersSection({Key? key}) : super(key: key);

  @override
  State<BannersSection> createState() => _InnovaUtemBanner();
}

class _InnovaUtemBanner extends State<BannersSection> {
  @override
  Widget build(BuildContext context) {
    final banners = RemoteConfigService.banners;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Novedades".toUpperCase(),
            textAlign: TextAlign.left,
            style: Get.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) =>
                MiUtemBanner(banner: banners[index]),
            separatorBuilder: (context, index) => Container(height: 10),
            itemCount: banners.length,
          ),
        ],
      ),
    );
  }
}
