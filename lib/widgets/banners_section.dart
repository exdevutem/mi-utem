import 'package:flutter/material.dart';
import 'package:mi_utem/widgets/banner.dart';

class BannersSection extends StatelessWidget {
  final List<IBanner> banners;

  const BannersSection({
    Key? key,
    required this.banners,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Novedades".toUpperCase(),
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
