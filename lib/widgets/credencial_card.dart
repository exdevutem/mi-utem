import 'package:barcode_widget/barcode_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/models/user/user.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/flip_widget.dart';
import 'package:mi_utem/widgets/profile_photo.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:url_launcher/url_launcher.dart';

class CredencialCard extends StatelessWidget {
  final User? user;
  final Carrera? carrera;
  final FlipController? controller;
  final Function(SwipeDirection?)? onFlip;

  CredencialCard({
    super.key,
    required this.user,
    required this.carrera,
    this.controller,
    this.onFlip
  });

  Widget _buildFront(BuildContext context) {
    double altoBanner = MediaQuery.of(context).size.height * 0.2;
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(20),
      child: Container(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: altoBanner - 40),
              child: ProfilePhoto(
                user: user,
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
                  colors: <Color>[
                    MainTheme.utemAzul,
                    MainTheme.utemVerde,
                  ],
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
                  Text(user?.nombreCompleto ?? "N/N",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  OccludeWrapper(
                    child: Text(user?.rut?.toString() ?? "Sin RUT",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  Divider(height: 1),
                  Spacer(),
                  Text(("${carrera?.nombre}".isEmpty ? "Sin carrera" : "${carrera?.nombre}"),
                    maxLines: 3,
                    style: TextStyle(
                      color: MainTheme.primaryDarkColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
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
                            data: "${user?.rut}",
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

  Widget _buildRear() {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: <Color>[
                  MainTheme.utemAzul,
                  MainTheme.utemVerde,
                ],
              ),
            ),
            height: 20,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Text(
                                "Credencial compatible con",
                                style: TextStyle(
                                    color: MainTheme.grey, fontSize: 12),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                "Sistema de Bibliotecas",
                                style: TextStyle(
                                  color: MainTheme.primaryDarkColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                "SIBUTEM",
                                style: TextStyle(
                                    color: MainTheme.primaryDarkColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 20),
                      CachedNetworkImage(
                        imageUrl: RemoteConfigService.credencialSibutemLogo,
                        height: 70,
                      )
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: MainTheme.primaryDarkColor,
                      ),
                    ),
                    padding: EdgeInsets.all(15),
                    child: MarkdownBody(
                      selectable: false,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: MainTheme.primaryDarkColor,
                        ),
                      ),
                      data: RemoteConfigService.credencialDisclaimer,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: MarkdownBody(
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: MainTheme.primaryDarkColor,
                          fontSize: 15,
                        ),
                        a: TextStyle(
                          color: MainTheme.primaryDarkColor,
                        ),
                      ),
                      onTapLink: (text, href, title) {
                        launchUrl(Uri.parse(href!));
                      },
                      data: RemoteConfigService.credencialInfo
                          .replaceAll(r"\n", "\n"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 53.98 / 85.60,
      child: FlipWidget(
        front: _buildFront(context),
        back: _buildRear(),
        controller: controller,
        onFlip: onFlip,
      ),
    );
  }
}

class CurvasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path = Path();
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.4,
        size.width * 0.6, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.8, 0, size.width, size.height * 0.2);

    path.lineTo(size.width, size.height);
    path.close();

    paint.color = MainTheme.utemAzul.withOpacity(0.7);
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.4, size.width, size.height * 0.4);

    path.lineTo(size.width, size.height);
    path.close();

    paint.color = MainTheme.utemVerde.withOpacity(0.7);
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height * 0.2);
    path.quadraticBezierTo(
        size.width * 0.25, 0, size.width * 0.5, size.height * 0.2);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.4, size.width, size.height * 0.2);
    path.lineTo(size.width, size.height);
    path.close();

    paint.color = MainTheme.primaryColor.withOpacity(0.5);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
