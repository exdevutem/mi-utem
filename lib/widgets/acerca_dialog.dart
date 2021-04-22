import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/acerca_aplicacion_content.dart';
import 'package:mi_utem/widgets/acerca_screen.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:timer_button/timer_button.dart';

class AcercaDialog extends StatefulWidget {
  AcercaDialog({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AcercaDialogState();
}

class _AcercaDialogState extends State<AcercaDialog> {
  Timer _timer;
  int _timeLeft = 30;
  bool _isDisabled = true;

  @override
  void initState() {
    _isDisabled = true;
    _timeLeft = 30;
    _startTimer();
    super.initState();
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
        child: Stack(
          children: [
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
                          FlatButton(
                            child: Text(
                              _isDisabled
                                  ? "Podrás cerrar en $_timeLeft"
                                  : "Saber más",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Theme.of(context).primaryColor,
                            disabledColor: Colors.grey,
                            onPressed: _isDisabled
                                ? null
                                : () {
                                    Get.back();
                                    Get.to(AcercaScreen());
                                  },
                          ),
                          if (!_isDisabled)
                            OutlineButton(
                              child: Text(
                                "Cerrar",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              color: Theme.of(context).primaryColor,
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2),
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
          ]
        ),
      ),
    );
  }
}
