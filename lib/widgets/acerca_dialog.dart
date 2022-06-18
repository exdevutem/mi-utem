import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/widgets/acerca_aplicacion_content.dart';
import 'package:mi_utem/widgets/acerca_screen.dart';

class AcercaDialog extends StatefulWidget {
  AcercaDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AcercaDialogState();
}

class _AcercaDialogState extends State<AcercaDialog> {
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  late int _timeLeft;
  bool _isActive = true;

  @override
  void initState() {
    _timeLeft = isProduction ? 15 : 3;
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_timeLeft == 0) {
          return setState(() {
            _isActive = false;
            timer.cancel();
          });
        }

        setState(() {
          _isActive = true;
          _timeLeft--;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Stack(children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: Card(
                    margin: EdgeInsets.all(20),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        AcercaAplicacionContent(
                          preTitulo: "Antes de empezar...",
                          titulo: "Bienvenido a Mi UTEM",
                        ),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.center,
                          children: [
                            TextButton(
                              child: Text(
                                _isActive
                                    ? "Podrás cerrar en $_timeLeft"
                                    : "Saber más",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: _isActive
                                  ? null
                                  : () {
                                      Get.back();
                                      Get.to(() => AcercaScreen());
                                    },
                            ),
                          ],
                        ),
                        if (!_isActive)
                          OutlinedButton(
                            child: Text(
                              "Cerrar",
                              style: TextStyle(color: Get.theme.primaryColor),
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        Container(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
