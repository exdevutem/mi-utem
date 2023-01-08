import 'package:flutter/material.dart';

import 'package:get/get.dart';

final _formKey = GlobalKey<FormState>();

class ErrorDialog extends StatelessWidget {
  final Widget? contenido;
  final Widget mensaje;
  ErrorDialog({
    this.contenido,
    required this.mensaje,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(child: this.mensaje),
                              if (this.contenido != null)
                                Padding(
                                    padding: EdgeInsets.all(20),
                                    child: this.contenido),
                              Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: TextButton(
                                    onPressed: () async {
                                      Get.back();
                                    },
                                    child: Text("Entendido 😥"),
                                  ))
                            ]))))));
  }
}
