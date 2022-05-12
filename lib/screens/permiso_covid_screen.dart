import 'dart:typed_data';

import 'package:barcode_image/barcode_image.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/permisos_covid_service.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/image_view_screen.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:image/image.dart' as dartImage;
import 'package:mi_utem/widgets/profile_photo.dart';

class PermisoCovidScreen extends StatefulWidget {
  const PermisoCovidScreen({
    Key? key,
    required this.permiso,
  }) : super(key: key);

  final PermisoCovid permiso;

  @override
  State<PermisoCovidScreen> createState() => _PermisoCovidScreenState();
}

class _PermisoCovidScreenState extends State<PermisoCovidScreen> {
  late Future<PermisoCovid> _propiedades;

  @override
  void initState() {
    super.initState();
    _propiedades = PermisosCovidService.getDetallesPermiso(widget.permiso.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text("Permiso de ingreso")),
      body: FutureBuilder(
        future: _propiedades,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            Get.back();
            return Container();
          }
          if (!snapshot.hasData) {
            return Center(
              child: LoadingIndicator(
                message: "Esto tardará un poco, paciencia...",
              ),
            );
          }

          return SingleChildScrollView(
            child: LoadedScreen(permiso: snapshot.data),
          );
        },
      ),
    );
  }
}

class LoadedScreen extends StatelessWidget {
  const LoadedScreen({
    Key? key,
    required this.permiso,
  }) : super(key: key);

  final PermisoCovid permiso;

  _openQr(String heroTag) {
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

    Get.to(
      () => ImageViewScreen(
        imageProvider: MemoryImage(data),
        heroTag: heroTag,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final f = new DateFormat('dd/MM/yyyy');
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        child: Column(
          children: [
            UsuarioDetalle(
              usuario: permiso.usuario!,
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
                onTap: () => _openQr("qr_${permiso.codigoQr!}"),
                child: Hero(
                  tag: "qr_${permiso.codigoQr!}",
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
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
            Container(height: 20),
            Text(
              "Permiso generado el ${f.format(permiso.fechaSolicitud!)}",
              style: Get.textTheme.caption,
            ),
            Container(height: 20),
          ],
        ),
      ),
    );
  }
}

class UsuarioDetalle extends StatelessWidget {
  const UsuarioDetalle({
    Key? key,
    required this.usuario,
  }) : super(key: key);

  final Usuario usuario;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          ProfilePhoto(usuario: usuario),
          Container(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usuario.nombre!,
                  maxLines: 2,
                  style: Get.textTheme.bodyText1,
                ),
                Text(
                  usuario.rut!.formateado(true),
                  style: Get.textTheme.bodyText2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetallesPermiso extends StatelessWidget {
  const DetallesPermiso({
    Key? key,
    this.campus,
    this.dependencias,
    this.jornada,
    this.vigencia,
    this.motivo,
  }) : super(key: key);

  final String? campus, dependencias, jornada, vigencia, motivo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BloqueDetalle(top: "Motivo", bottom: motivo),
          if (campus != null || dependencias != null) Container(height: 20),
          if (campus != null || dependencias != null)
            Row(
              children: [
                Expanded(
                  child: BloqueDetalle(
                    top: "Campus",
                    bottom: campus,
                  ),
                ),
                Expanded(
                  child: BloqueDetalle(
                    top: "Dependencias",
                    bottom: dependencias,
                  ),
                ),
              ],
            ),
          if (jornada != null || vigencia != null) Container(height: 20),
          if (jornada != null || vigencia != null)
            Row(
              children: [
                Expanded(
                  child: BloqueDetalle(
                    top: "Jornada",
                    bottom: jornada,
                  ),
                ),
                Expanded(
                  child: BloqueDetalle(
                    top: "Vigencia",
                    bottom: vigencia,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class BloqueDetalle extends StatelessWidget {
  const BloqueDetalle({
    Key? key,
    required this.top,
    this.bottom,
  }) : super(key: key);

  final String top;
  final String? bottom;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                top.toUpperCase(),
                maxLines: 2,
                style: Get.textTheme.caption!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: MainTheme.grey,
                ),
              ),
              Text(
                bottom ?? "Sin información",
                style: Get.textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
