import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/widgets/acerca/dialog/acerca_aplicacion_content.dart';
import 'package:mi_utem/widgets/acerca/dialog/acerca_dialog_action_button.dart';

class AcercaDialog extends StatefulWidget {
  const AcercaDialog({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AcercaDialogState();
}

class _AcercaDialogState extends State<AcercaDialog> {
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  Timer? _timer;

  late int _timeLeft;
  bool _isActive = true;

  @override
  void initState() {
    _timeLeft = isProduction ? 15 : 3;
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(
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
                        AcercaDialogActionButton(isActive: _isActive, timeLeft: _timeLeft),
                        if (!_isActive)
                          OutlinedButton(
                            child: Text("Cerrar",
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
