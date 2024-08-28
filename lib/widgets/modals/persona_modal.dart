import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/core/models/user/persona/persona.dart';
import 'package:mi_utem/widgets/profile_photo.dart';
import 'package:mi_utem/widgets/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonaModal extends StatelessWidget {
  final Persona persona;

  const PersonaModal({
    super.key,
    required this.persona,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Stack(
      children: [
        Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.only(top: 80),
          child: Card(
            margin: const EdgeInsets.all(20),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 10, top: 20),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ListTile(
                  title: Text("Nombre Completo",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onLongPress: () async {
                    await FlutterClipboard.copy(persona.nombreCompleto);
                    showTextSnackbar(context, title: "¡Copiado!", message: "Correo copiado al portapapeles");
                  },
                  subtitle: Text(persona.nombreCompletoCapitalizado,
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 18,
                    ),
                  ),
                ),
                Divider(height: 5),
                ListTile(
                  title: Text("Rut",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onLongPress: () async {
                    await FlutterClipboard.copy(persona.rut.toString());
                    showTextSnackbar(context, title: "¡Copiado!", message: "Rut copiado al portapapeles");
                  },
                  onTap: () async {
                    await launchUrl(Uri.parse("mailto:${persona.rut.toString()}"));
                  },
                  subtitle: Text(persona.rut.toString(),
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: ProfilePhoto(
            iniciales: persona.iniciales,
            radius: 60,
            editable: false,
          ),
        ),
      ],
    ),
  );
}
