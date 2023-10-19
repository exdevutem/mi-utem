import 'package:barcode_image/barcode_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as dartImage;
import 'package:mi_utem/config/routes/routes.dart';
import 'package:mi_utem/widgets/image_view_screen.dart';

void openBarcodeView(
  String code, {
  required Size size,
  EdgeInsets padding = const EdgeInsets.all(25),
  String? heroTag,
  Barcode? type,
}) {
  final image = dartImage.Image(size.width.toInt(), size.height.toInt());

  dartImage.fill(image, dartImage.getColor(255, 255, 255));
  drawBarcode(
    image,
    type ?? Barcode.qrCode(),
    code,
    x: padding.left.toInt(),
    y: padding.top.toInt(),
    width: (size.width - padding.horizontal).toInt(),
    height: (size.height - padding.vertical).toInt(),
  );

  Uint8List data = Uint8List.fromList(dartImage.encodePng(image));

  Get.to(
    () => ImageViewScreen(
      imageProvider: MemoryImage(data),
      heroTag: heroTag,
      occlude: true,
    ),
    routeName: Routes.imageView,
  );
}
