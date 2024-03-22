import 'dart:typed_data';

import 'package:barcode_image/barcode_image.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:image/image.dart' as dartImage;
import 'package:intl/intl.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/models/user/user.dart';
import 'package:mi_utem/services_new/interfaces/qr_pass_service.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/field_list_tile.dart';
import 'package:mi_utem/widgets/image_view_screen.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/profile_photo.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';
import 'package:watch_it/watch_it.dart';

class PermisoCovidScreen extends StatefulWidget {
  final String passId;

  const PermisoCovidScreen({super.key, required this.passId});

  @override
  State<PermisoCovidScreen> createState() => _PermisoCovidScreenState();
}

class _PermisoCovidScreenState extends State<PermisoCovidScreen> {

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppBar(title: Text("Permiso de ingreso")),
    body: PullToRefresh(
      onRefresh: () async => setState(() {}),
      child: FutureBuilder<PermisoCovid?>(
        future: di.get<QRPassService>().getDetallesPermiso(widget.passId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error is CustomException ? (snapshot.error as CustomException).message : "No sabemos lo que ocurrió. Por favor intenta más tarde.";
            logger.e("Error al cargar permiso", snapshot.error);
            return Center(
              child: CustomErrorWidget(error: error),
            );
          }

          final permiso = snapshot.data;
          if(!snapshot.hasData) {
            return Center(
              child: LoadingIndicator(
                message: "Esto tardará un poco, paciencia...",
              ),
            );
          }

          if(permiso == null) {
            return const Center(
              child: CustomErrorWidget(
                title: "Permiso no encontrado",
                emoji: "\u{1F914}",
              ),
            );
          }

          return SingleChildScrollView(child: QRCard(permiso: permiso));
        },
      ),
    ),
  );
}


class QRCard extends StatelessWidget {
  const QRCard({
    Key? key,
    required this.permiso,
  }) : super(key: key);

  final PermisoCovid permiso;

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
          UsuarioDetalle(
            user: permiso.user!,
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

class UsuarioDetalle extends StatelessWidget {
  final User user;

  const UsuarioDetalle({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          ProfilePhoto(user: user),
          Container(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.nombreCompletoCapitalizado,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Container(height: 4),
                Text("${user.rut}",
                  style: Theme.of(context).textTheme.bodyMedium,
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
          FieldListTile(
            padding: EdgeInsets.zero,
            title: "Motivo",
            value: motivo,
          ),
          if (campus != null || dependencias != null) Container(height: 20),
          if (campus != null || dependencias != null)
            Row(
              children: [
                Expanded(
                  child: FieldListTile(
                    padding: EdgeInsets.zero,
                    title: "Campus",
                    value: campus,
                  ),
                ),
                Expanded(
                  child: FieldListTile(
                    padding: EdgeInsets.zero,
                    title: "Dependencias",
                    value: dependencias,
                  ),
                ),
              ],
            ),
          if (jornada != null || vigencia != null) Container(height: 20),
          if (jornada != null || vigencia != null)
            Row(
              children: [
                Expanded(
                  child: FieldListTile(
                    padding: EdgeInsets.zero,
                    title: "Jornada",
                    value: jornada,
                  ),
                ),
                Expanded(
                  child: FieldListTile(
                    padding: EdgeInsets.zero,
                    title: "Vigencia",
                    value: vigencia,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
