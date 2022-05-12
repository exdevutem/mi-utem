import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewScreen extends StatefulWidget {
  final ImageProvider imageProvider;
  final String? heroTag;
  ImageViewScreen({Key? key, required this.imageProvider, this.heroTag})
      : super(key: key);

  @override
  _ImageViewScreenState createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: PhotoView(
              imageProvider: widget.imageProvider,
              heroAttributes: widget.heroTag != null
                  ? PhotoViewHeroAttributes(tag: widget.heroTag!)
                  : null,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black.withOpacity(0.5),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 20,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
