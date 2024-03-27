import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/widgets/image_view_screen.dart';

class DefaultNetworkImage extends StatelessWidget {
  final String? url;

  DefaultNetworkImage({
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl: "$url",
        imageBuilder: (context, imageProvider) => GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => ImageViewScreen(imageProvider: imageProvider))),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: Center(
            child: Icon(Icons.photo),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: Center(
            child: Icon(Icons.photo),
          ),
        ),
      ),
    );
  }
}
