import 'package:beamer/beamer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/error_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class NotReadyDialog extends StatelessWidget {
  const NotReadyDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorDialog(
      mensaje: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 16,
          ),
          children: [
            TextSpan(
              text: "Aún no estás listo para esto",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: MainTheme.primaryDarkColor,
              ),
            ),
            TextSpan(
              text: "\n\n👀\n\n",
              style: TextStyle(
                fontSize: 80,
              ),
            ),
            TextSpan(
                text:
                    "• Si eres estudiante nuevo, debes esperar a que se habilite la plataforma para ti. \n• Si eres estudiante antiguo y tampoco puedes acceder a la plataforma web "),
            TextSpan(
              text: "mi.utem.cl",
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launchUrl(
                    Uri.parse(
                      "https://mi.utem.cl/?ref=appMiUtemInndev",
                    ),
                  );
                },
            ),
            TextSpan(text: ", contáctate con "),
            TextSpan(
              text: "soporte.sisei@utem.cl",
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launchUrl(
                    Uri.parse(
                      "mailto:soporte.sisei@utem.cl",
                    ),
                  );
                },
            ),
            TextSpan(
                text:
                    ", ellos podrán ayudarte. \n• Si el problema solo es la app, contáctanos a "),
            TextSpan(
              text: "nuestras redes sociales",
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Beamer.of(context).beamToNamed('/acerca');
                },
            ),
          ],
        ),
      ),
    );
  }
}
