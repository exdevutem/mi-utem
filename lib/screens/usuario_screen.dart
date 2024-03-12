import 'dart:core';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/user/user.dart';
import 'package:mi_utem/services/docentes_service.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/services_new/interfaces/auth_service.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/image_view_screen.dart';
import 'package:mi_utem/widgets/loading_dialog.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/profile_photo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch_it/watch_it.dart';

class UsuarioScreen extends StatefulWidget {
  final int tipo;
  final Map<String, dynamic>? query;
  final Asignatura? asignatura;

  UsuarioScreen({
    super.key,
    this.tipo = 0,
    this.query,
    this.asignatura,
  });

  @override
  _UsuarioScreenState createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  final _authService = di.get<AuthService>();

  Future<User>? _userFuture;
  User? _user;

  @override
  void initState() {
    ReviewService.addScreen("UsuarioScreen");
    super.initState();
    _userFuture = _getUsuario();
  }

  Future<User> _getUsuario() async {
    try {
      User? user;
      if (widget.tipo == 2) {
        print(widget.query);
        if (widget.asignatura == null) {
          user = await DocentesService.traerUnDocente(widget.query!["nombre"]);
        } else {
          user = await DocentesService.asignarUnDocente(
              widget.query!["nombre"],
              widget.asignatura!.codigo,
              widget.asignatura!.nombre);
        }

        setState(() {
          _user = user;
        });
      } else {
        user = await _authService.getUser();
        setState(() {
          _user = user;
        });
      }

      if (user == null) {
        throw "No se pudo obtener el usuario";
      }

      return user;
    } catch (e) {
      throw e;
    }
  }

  Future<void> _changeFoto(String imagen) async {
    Get.dialog(
      LoadingDialog(),
      barrierDismissible: false,
    );

    try {
      User? user = await _authService.updateProfilePicture(imagen);
      Get.back();

      setState(() {
        _user = user;
      });

      return;
    } catch (e) {
      Get.back();
      print("Error cambiando la imagen ${e.toString()}");
      Get.snackbar(
        "Error",
        "No se pudo cambiar la foto",
        colorText: Colors.white,
        backgroundColor: Get.theme.primaryColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(20),
      );
    }
  }

  List<Widget> get _datosPersonales {
    List<Widget> lista = [];
    if(_user == null) {
      return lista;
    }

    if (_user?.nombreDisplayCapitalizado?.isEmpty == false) {
      lista.add(ListTile(
        title: Text("Nombre",
          style: TextStyle(color: Colors.grey),
        ),
        subtitle: Text(_user!.nombreCompleto!,
          style: TextStyle(
            color: Colors.grey[900],
            fontSize: 18,
          ),
        ),
      ));
    } else {
      if (_user?.nombres?.isEmpty == false) {
        lista.add(
          ListTile(
            title: Text("Nombres",
              style: TextStyle(color: Colors.grey),
            ),
            subtitle: Text(_user!.nombres!,
              style: TextStyle(
                color: Colors.grey[900],
                fontSize: 18,
              ),
            ),
          ),
        );
      }

      if (_user?.apellidos?.isEmpty == false) {
        lista.add(Divider(height: 1));
        lista.add(
          ListTile(
            title: Text("Apellidos",
              style: TextStyle(color: Colors.grey),
            ),
            subtitle: Text(_user!.apellidos!,
              style: TextStyle(
                color: Colors.grey[900],
                fontSize: 18,
              ),
            ),
          ),
        );
      }
    }

    if (_user?.correoUtem?.isEmpty == false) {
      lista.add(Divider(height: 1));
      lista.add(ListTile(
        title: Text("Correo Institucional",
          style: TextStyle(color: Colors.grey),
        ),
        onLongPress: widget.tipo != 0 ? () async {
          await FlutterClipboard.copy(_user!.correoUtem!);
          Get.snackbar(
            "¡Copiado!",
            "Correo copiado al portapapeles",
            colorText: Colors.white,
            backgroundColor: Get.theme.primaryColor,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(20),
          );
        } : null,
        onTap: widget.tipo != 0 ? () async {
          await launchUrl(Uri.parse("mailto:${_user?.correoUtem ?? ""}"));
        } : null,
        subtitle: Text(_user!.correoUtem ?? "",
          style: TextStyle(
            color: Colors.grey[900],
            fontSize: 18,
          ),
        ),
      ));
    }
    if (_user?.correoPersonal?.isEmpty == false) {
      lista.add(Divider(height: 1));
      lista.add(
        ListTile(
          title: Text("Correo Personal",
            style: TextStyle(color: Colors.grey),
          ),
          onLongPress: widget.tipo != 0 ? () async {
            await FlutterClipboard.copy(_user!.correoPersonal!);
            Get.snackbar(
              "¡Copiado!",
              "Correo copiado al portapapeles",
              colorText: Colors.white,
              backgroundColor: Get.theme.primaryColor,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.all(20),
            );
          } : null,
          onTap: widget.tipo != 0 ? () async {
            await launchUrl(Uri.parse("mailto:${_user?.correoPersonal ?? ""}"));
          } : null,
          subtitle: Text(_user!.correoPersonal ?? "",
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 18,
            ),
          ),
        ),
      );
    }

    if (widget.tipo == 0 && _user!.rut != null) {
      lista.add(Divider(height: 1));
      lista.add(ListTile(
        title: Text("RUT",
          style: TextStyle(color: Colors.grey),
        ),
        subtitle: Text("${_user!.rut}",
          style: TextStyle(
            color: Colors.grey[900],
            fontSize: 18,
          ),
        ),
      ));
    }

    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(widget.tipo == 0 ? "Perfil" : widget.query!["nombre"]),
      ),
      body: FutureBuilder(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(
              title: "Ocurrió un error al obtener el perfil",
              error: snapshot.error,
            );
          }

          if (snapshot.hasData) {
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
                        children: _datosPersonales,
                      ),
                    ),
                  ),
                  Center(
                    child: ProfilePhoto(
                      user: _user,
                      radius: 60,
                      editable: widget.tipo == 0,
                      onImage: widget.tipo == 0 ? _changeFoto : null,
                      onImageTap: (context, imageProvider) {
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => ImageViewScreen(
                          imageProvider: imageProvider,
                        )));
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Center(
                    child: LoadingIndicator(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
