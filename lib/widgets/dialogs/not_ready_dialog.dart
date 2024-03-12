import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/acerca/acerca_screen.dart';
import 'package:mi_utem/widgets/error_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class NotReadyDialog extends StatelessWidget {
  const NotReadyDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) => ErrorDialog(
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
          const TextSpan(
            text: "\n\n\u{1F440}\n\n",
            style: TextStyle(
              fontSize: 80,
            ),
          ),
          const TextSpan(text: "• Si eres estudiante nuevo, debes esperar a que se habilite la plataforma para ti. \n• Si eres estudiante antiguo y tampoco puedes acceder a la plataforma web "),
          TextSpan(
            text: "mi.utem.cl",
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => launchUrl(Uri.parse("https://mi.utem.cl/?ref=appMiUtemInndev")),
          ),
          const TextSpan(text: ", contáctate con "),
          TextSpan(
            text: "soporte.sisei@utem.cl",
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => launchUrl(Uri.parse("mailto:soporte.sisei@utem.cl")),
          ),
          TextSpan(text: ", ellos podrán ayudarte. \n• Si el problema solo es la app, contáctanos a "),
          TextSpan(
            text: "nuestras redes sociales",
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => AcercaScreen())),
          ),
        ],
      ),
    ),
  );
}
