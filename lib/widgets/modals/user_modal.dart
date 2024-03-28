import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/models/user/user.dart';
import 'package:mi_utem/widgets/profile_photo.dart';
import 'package:mi_utem/widgets/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class UserModal extends StatelessWidget {
  final User user;

  const UserModal({
    super.key,
    required this.user,
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
                    await FlutterClipboard.copy(user.nombreCompleto);
                    showTextSnackbar(context, title: "¡Copiado!", message: "Correo copiado al portapapeles");
                  },
                  subtitle: Text(user.nombreCompletoCapitalizado,
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 18,
                    ),
                  ),
                ),
                Divider(height: 5),
                ListTile(
                  title: Text("Correo Personal",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onLongPress: () async {
                    await FlutterClipboard.copy(user.correoUtem!);
                    showTextSnackbar(context, title: "¡Copiado!", message: "Correo copiado al portapapeles");
                  },
                  onTap: () async {
                    await launchUrl(Uri.parse("mailto:${user.correoUtem ?? ""}"));
                  },
                  subtitle: Text(user.correoUtem!,
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
            user: user,
            radius: 60,
            editable: false,
          ),
        ),
      ],
    ),
  );
}
