import 'dart:core';

import 'package:clipboard/clipboard.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/docentes_service.dart';
import 'package:mi_utem/services/perfil_service.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/image_view_screen.dart';
import 'package:mi_utem/widgets/loading_dialog.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/profile_photo.dart';
import 'package:url_launcher/url_launcher.dart';

class UsuarioScreen extends StatefulWidget {
  final int tipo;
  final Map<String, dynamic>? query;
  final Asignatura? asignatura;
  UsuarioScreen({Key? key, this.tipo = 0, this.query, this.asignatura})
      : super(key: key);

  @override
  _UsuarioScreenState createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  Future<Usuario>? _usuarioFuture;
  Usuario? _usuario;

  @override
  void initState() {
    ReviewService.addScreen("UsuarioScreen");
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'UsuarioScreen');
    super.initState();
    _usuarioFuture = _getUsuario();
  }

  Future<Usuario> _getUsuario() async {
    try {
      Usuario usuario;
      if (widget.tipo == 2) {
        print(widget.query);
        if (widget.asignatura == null) {
          usuario =
              await DocentesService.traerUnDocente(widget.query!["nombre"]);
        } else {
          usuario = await DocentesService.asignarUnDocente(
              widget.query!["nombre"],
              widget.asignatura!.codigo,
              widget.asignatura!.nombre);
        }

        setState(() {
          _usuario = usuario;
        });
      } else {
        usuario = await PerfilService.getLocalUsuario();
        setState(() {
          _usuario = usuario;
        });
      }

      return usuario;
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
      Usuario usuario = await PerfilService.changeFoto(imagen);
      Get.back();

      setState(() {
        _usuario = usuario;
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
    if (_usuario != null) {
      if (_usuario!.nombre != null && _usuario!.nombre!.isNotEmpty) {
        lista.add(ListTile(
          title: Text(
            "Nombre",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          subtitle: Text(
            _usuario!.nombreCompleto!,
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 18,
            ),
          ),
        ));
      } else {
        if (_usuario!.nombres != null && _usuario!.nombres!.isNotEmpty) {
          lista.add(
            ListTile(
              title: Text(
                "Nombres",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              subtitle: Text(
                _usuario!.nombres!,
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 18,
                ),
              ),
            ),
          );
        }

        if (_usuario!.apellidos != null && _usuario!.apellidos!.isNotEmpty) {
          lista.add(Divider(height: 1));
          lista.add(
            ListTile(
              title: Text(
                "Apellidos",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              subtitle: Text(
                _usuario!.apellidos!,
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 18,
                ),
              ),
            ),
          );
        }
      }

      if (_usuario!.correoUtem != null && _usuario!.correoUtem!.isNotEmpty) {
        lista.add(Divider(height: 1));
        lista.add(ListTile(
          title: Text(
            "Correo",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          onLongPress: widget.tipo != 0
              ? () async {
                  await FlutterClipboard.copy(_usuario!.correoUtem!);
                  Get.snackbar(
                    "¡Copiado!",
                    "Correo copiado al portapapeles",
                    colorText: Colors.white,
                    backgroundColor: Get.theme.primaryColor,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: EdgeInsets.all(20),
                  );
                }
              : null,
          onTap: widget.tipo != 0
              ? () async {
                  await launchUrl(
                    Uri.parse(
                      "mailto:${_usuario!.correoUtem}",
                    ),
                  );
                }
              : null,
          subtitle: Text(
            _usuario!.correoUtem ?? "",
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 18,
            ),
          ),
        ));
      }
      if (_usuario!.correoPersonal != null &&
          _usuario!.correoPersonal!.isNotEmpty) {
        lista.add(Divider(height: 1));
        lista.add(
          ListTile(
            title: Text(
              "Correo",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onLongPress: widget.tipo != 0
                ? () async {
                    await FlutterClipboard.copy(_usuario!.correoPersonal!);
                    Get.snackbar(
                      "¡Copiado!",
                      "Correo copiado al portapapeles",
                      colorText: Colors.white,
                      backgroundColor: Get.theme.primaryColor,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: EdgeInsets.all(20),
                    );
                  }
                : null,
            onTap: widget.tipo != 0
                ? () async {
                    await launchUrl(
                      Uri.parse(
                        "mailto:${_usuario!.correoPersonal}",
                      ),
                    );
                  }
                : null,
            subtitle: Text(
              _usuario!.correoPersonal ?? "",
              style: TextStyle(
                color: Colors.grey[900],
                fontSize: 18,
              ),
            ),
          ),
        );
      }

      if (widget.tipo == 0 && _usuario!.rut != null) {
        lista.add(Divider(height: 1));
        lista.add(ListTile(
          title: Text(
            "RUT",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          subtitle: Text(
            _usuario!.rut!.formateado(true),
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 18,
            ),
          ),
        ));
      }
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
        future: _usuarioFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(
                texto: "Ocurrió un error al obtener el perfil",
                error: snapshot.error);
          } else {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 80),
                      child: Card(
                        margin: EdgeInsets.all(20),
                        child: ListView(
                          padding: EdgeInsets.only(bottom: 10, top: 20),
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          children: _datosPersonales,
                        ),
                      ),
                    ),
                    Center(
                      child: ProfilePhoto(
                          usuario: _usuario,
                          radius: 60,
                          editable: widget.tipo == 0,
                          onImage: widget.tipo == 0
                              ? (image) {
                                  _changeFoto(image);
                                }
                              : null,
                          onImageTap: (context, imageProvider) {
                            Get.to(
                              () =>
                                  ImageViewScreen(imageProvider: imageProvider),
                            );
                          }),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: LoadingIndicator(),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
