import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:mi_utem/core/models/carrera.dart';
import 'package:mi_utem/core/models/user/estudiante.dart';
import 'package:mi_utem/core/services/carrera_service.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/profile_photo.dart';

class CredencialFront extends StatelessWidget {

  final Estudiante estudiante;

  const CredencialFront({
    super.key,
    required this.estudiante,
  });

  @override
  Widget build(BuildContext context) {
    double altoBanner = MediaQuery.of(context).size.height * 0.2;
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(20),
      child: Container(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: EdgeInsets.only(top: altoBanner - 40),
              child: ProfilePhoto(
                base64Data: estudiante.fotoUrl,
                iniciales: estudiante.iniciales,
                radius: 50,
                borderWidth: 5,
              ),
            ),
            Container(
              height: altoBanner,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [MainTheme.utemAzul, MainTheme.utemVerde],
                ),
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Image.asset(
                    'assets/images/utem_logo_negativo.png',
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: altoBanner + 10),
              padding: EdgeInsets.fromLTRB(30, 60, 30, 20),
              color: Colors.white,
              child: Column(
                children: [
                  Text(estudiante.nombreCompleto,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  OccludeWrapper(
                    child: Text(estudiante.rut.toString(),
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  Divider(height: 1),
                  Spacer(),
                  FutureBuilder<Carrera>(
                    future: Get.find<CarreraService>().getCarrera(),
                    builder: (ctx, snapshot) {
                      final carrera = snapshot.data;

                      return Text(carrera?.nombre ?? "Sin carrera",
                        maxLines: 3,
                        style: TextStyle(
                          color: MainTheme.primaryDarkColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Colors.grey),
                            left: BorderSide(color: Colors.grey),
                            bottom: BorderSide(color: Colors.grey),
                            right: BorderSide(color: Colors.grey),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: OccludeWrapper(
                          child: BarcodeWidget(
                            barcode: Barcode.code39(),
                            data: "${estudiante.rut?.rut}",
                            width: 200,
                            height: 50,
                            drawText: false,
                          ),
                        ),
                      ),
                      Container(height: 10),
                      MarkdownBody(
                        selectable: false,
                        styleSheet: MarkdownStyleSheet(
                          textAlign: WrapAlignment.center,
                          p: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        data: RemoteConfigService.credencialBarras,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ].reversed.toList(),
        ),
      ),
    );
  }
}
