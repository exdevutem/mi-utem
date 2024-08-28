import 'dart:typed_data';

import 'package:barcode_image/barcode_image.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:image/image.dart' as dartImage;
import 'package:intl/intl.dart';
import 'package:mi_utem/core/models/permiso_ingreso.dart';
import 'package:mi_utem/widgets/image/image_view_screen.dart';
import 'package:mi_utem/widgets/permiso_ingreso/detalles_permiso.dart';
import 'package:mi_utem/widgets/permiso_ingreso/usuario_detalle.dart';

class QRCard extends StatelessWidget {
  final PermisoIngreso permiso;

  const QRCard({
    super.key,
    required this.permiso,
  });


  _openQr(BuildContext context, String heroTag) {
    final image = dartImage.Image(500, 500);

    dartImage.fill(image, dartImage.getColor(255, 255, 255));
    drawBarcode(
      image,
      Barcode.qrCode(),
      permiso.codigoQr!,
      x: 25,
      y: 25,
      width: 450,
      height: 450,
    );

    Uint8List data = Uint8List.fromList(dartImage.encodePng(image));

    Navigator.push(context, MaterialPageRoute(builder: (ctx) => ImageViewScreen(
      imageProvider: MemoryImage(data),
      heroTag: heroTag,
      occlude: true,
    )));
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Card(
      child: Column(
        children: [
          PersonaDetalle(
            estudiante: permiso.persona!,
          ),
          Divider(thickness: 1, color: Color(0xFFFEEEEE)),
          DetallesPermiso(
            campus: permiso.campus,
            dependencias: permiso.dependencia,
            jornada: permiso.jornada,
            vigencia: permiso.vigencia,
            motivo: permiso.motivo,
          ),
          Divider(thickness: 1, color: Color(0xFFFEEEEE)),
          Container(height: 20),
          Center(
            child: InkWell(
              onTap: () => _openQr(context, "qr_${permiso.codigoQr!}"),
              child: Hero(
                tag: "qr_${permiso.codigoQr!}",
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  child: OccludeWrapper(
                    child: BarcodeWidget(
                      barcode: Barcode.qrCode(),
                      height: 200,
                      width: 200,
                      data: permiso.codigoQr!,
                      drawText: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(height: 20),
          Text("Permiso generado el ${DateFormat('dd/MM/yyyy').format(permiso.fechaSolicitud!)}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Container(height: 20),
        ],
      ),
    ),
  );
}