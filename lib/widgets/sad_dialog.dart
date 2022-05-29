import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/widgets/acerca_screen.dart';

final _formKey = GlobalKey<FormState>();

class SadDialog extends StatelessWidget {
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
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Nope.\nNo puedes iniciar sesión 😔",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Esta aplicación no está funcionando (aún).",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: new TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                        children: [
                          new TextSpan(
                            text: "Puedes enviar un correo a ",
                          ),
                          new TextSpan(
                            text: "soporte.sisei@utem.cl",
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () async {
                                /* final Email email = Email(
                                  body:
                                      'Por favor, me gustaría que habilitaran pronto la aplicación móvil Mi UTEM lo antes posible. Es una genial idea.',
                                  subject: 'Habilitar aplicación movil Mi UTEM',
                                  recipients: ['soporte.sisei@utem.cl'],
                                  isHTML: false,
                                );

                                await FlutterEmailSender.send(email); */
                              },
                          ),
                          new TextSpan(
                            text:
                                " contándoles lo mucho que quieres que esta aplicación esté funcionando o ",
                          ),
                          new TextSpan(
                            text:
                                "presionar el botón y conocer más detalles de este proyecto.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: TextButton(
                      onPressed: () async {
                        Get.to(() => AcercaScreen());
                      },
                      child: Text("Quiero saber más"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
