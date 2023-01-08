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

  late Timer _timer;
  late int _timeLeft;
  bool _isDisabled = true;

  @override
  void initState() {
    _isDisabled = true;
    _timeLeft = isProduction ? 30 : 3;
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_timeLeft == 0) {
          setState(() {
            _isDisabled = false;
            timer.cancel();
          });
        } else {
          setState(() {
            _isDisabled = true;
            _timeLeft--;
          });
        }
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
                                _isDisabled
                                    ? "Podrás cerrar en $_timeLeft"
                                    : "Saber más",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: _isDisabled
                                  ? null
                                  : () {
                                      Get.back();
                                      Get.to(() => AcercaScreen());
                                    },
                            ),
                          ],
                        ),
                        if (!_isDisabled)
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
