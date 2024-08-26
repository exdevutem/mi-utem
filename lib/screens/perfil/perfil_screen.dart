import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/core/models/user/user.dart';
import 'package:mi_utem/core/services/auth_service.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/models/preferencia.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/image/image_view_screen.dart';
import 'package:mi_utem/widgets/loading/loading_indicator.dart';
import 'package:mi_utem/widgets/profile_photo.dart';
import 'package:mi_utem/widgets/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class PerfilScreen extends StatefulWidget {

  const PerfilScreen({
    super.key,
  });

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {

  String? apodo;

  @override
  void initState() {
    Preferencia.apodo.get().then((apodo) => setState(() => this.apodo = apodo));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppBar(
      title: Text("Perfil"),
    ),
    body: SafeArea(child: FutureBuilder<User?>(
      future: Get.find<AuthService>().getUser(),
      builder: (ctx, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator.centeredDefault();
        }

        final user = snapshot.data;
        if(snapshot.hasError || !snapshot.hasData || user == null) {
          return Center(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: CustomErrorWidget(
                emoji: "\u{1F622}",
                title: (snapshot.error is CustomException ? (snapshot.error as CustomException).message : "Ocurrió un error al obtener los estudiantes"),
              ),
            ),
          );
        }

        return SingleChildScrollView(
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
                        title: Text("Nombre",
                          style: TextStyle(color: Colors.grey),
                        ),
                        subtitle: Text("${user.persona.nombreCompletoCapitalizado}",
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 18,
                          ),
                        ),
                      ),
                      if(apodo != null) Divider(height: 1),
                      if(apodo != null) ListTile(
                        title: Text("Apodo",
                          style: TextStyle(color: Colors.grey),
                        ),
                        subtitle: Text("$apodo",
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Divider(height: 1),
                      ListTile(
                        title: Text("RUT",
                          style: TextStyle(color: Colors.grey),
                        ),
                        subtitle: Text("${user.persona.rut}",
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 18,
                          ),
                        ),
                        onLongPress: () async {
                          await FlutterClipboard.copy(user.persona.rut.toString());
                          showTextSnackbar(context, title: "¡Copiado!", message: "Rut copiado al portapapeles");
                        },
                      ),
                      Divider(height: 1),
                      ListTile(
                        title: Text("Correo Institucional",
                          style: TextStyle(color: Colors.grey),
                        ),
                        subtitle: Text("${user.persona.correoUtem}",
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 18,
                          ),
                        ),
                        onTap: () => launchUrl(Uri.parse("mailto:${user.persona.correoUtem}")),
                        onLongPress: () async {
                          await FlutterClipboard.copy(user.persona.correoUtem!);
                          showTextSnackbar(context, title: "¡Copiado!", message: "Correo copiado al portapapeles");
                        },
                      ),
                      Divider(height: 1),
                      ListTile(
                        title: Text("Correo Personal",
                          style: TextStyle(color: Colors.grey),
                        ),
                        subtitle: Text("${user.persona.correoPersonal}",
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 18,
                          ),
                        ),
                        onTap: () => launchUrl(Uri.parse("mailto:${user.persona.correoPersonal}")),
                        onLongPress: () async {
                          await FlutterClipboard.copy(user.persona.correoPersonal!);
                          showTextSnackbar(context, title: "¡Copiado!", message: "Correo copiado al portapapeles");
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: ProfilePhoto(
                  fotoUrl: user.persona.fotoUrl,
                  iniciales: user.persona.iniciales,
                  radius: 60,
                  editable: false,
                  onImage: (imagenBase64) async {
                    // Actualizar foto de perfil en miutem
                    showTextSnackbar(context, title: "¡Listo!", message: "Guardamos tu foto de perfil");
                    setState(() {});
                  },
                  onImageTap: (context, imageProvider) => Navigator.push(context, MaterialPageRoute(builder: (ctx) => ImageViewScreen(
                    imageProvider: imageProvider,
                  ))),
                ),
              ),
            ],
          ),
        );
      },
    )),
  );
}
