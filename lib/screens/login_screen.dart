import 'dart:convert';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/screens/main_screen.dart';
import 'package:mi_utem/services/auth_service.dart';
import 'package:mi_utem/services/config_service.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/acerca_dialog.dart';
import 'package:mi_utem/widgets/acerca_screen.dart';
import 'package:mi_utem/widgets/error_dialog.dart';
import 'package:mi_utem/widgets/loading_dialog.dart';
import 'package:mi_utem/widgets/login_text_form_field.dart';

//import 'package:new_version/new_version.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _correo, _contrasenia;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late VideoPlayerController _controller;

  FirebaseRemoteConfig? _remoteConfig;

  @override
  void initState() {
    super.initState();
    _remoteConfig = ConfigService.config;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'LoginScreen');
    _correo = null;
    _contrasenia = null;
    _controller = VideoPlayerController.asset('assets/videos/login_bg.mp4')
      ..setVolume(0)
      ..play()
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
      });

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _checkAndPerformUpdate();
    });
  }

  Future<void> _checkAndPerformUpdate() async {
    /* try {
      VersionStatus status =
          await NewVersion(context: context).getVersionStatus();
      print("status.localVersion ${status.localVersion}");
      print("status.storeVersion ${status.storeVersion}");

      var localVersion = status.localVersion.split(".");
      var storeVersion = status.storeVersion.split(".");
      if (storeVersion[0].compareTo(localVersion[0]) > 0) {
        if (Platform.isAndroid) {
          AppUpdateInfo info = await InAppUpdate.checkForUpdate();

          if (info.updateAvailable == true) {
            await InAppUpdate.performImmediateUpdate();
          }
        }
      } else if (storeVersion[1].compareTo(localVersion[1]) > 0) {
        if (Platform.isAndroid) {
          AppUpdateInfo info = await InAppUpdate.checkForUpdate();

          if (info.updateAvailable == true) {
            await InAppUpdate.startFlexibleUpdate();
            await InAppUpdate.completeFlexibleUpdate();
          }
        }
      } else if (storeVersion[2].compareTo(localVersion[2]) > 0) {
        print("MINOR");
      }

      return;
    } catch (error) {
      print("_checkAndPerformUpdate Error: ${error.toString()}");
    } */
  }

  String get _creditText {
    List<dynamic> texts = jsonDecode(_remoteConfig!.getString(
      ConfigService.CREDITOS,
    ));

    Random random = new Random();

    return texts[random.nextInt(texts.length)];
  }

  BoxDecoration get _backgroundDecoration {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/login_bg.png'),
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = _controller.value.size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                decoration: _backgroundDecoration,
              ),
              ClipRect(
                child: OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  alignment: Alignment.center,
                  child: Container(
                    decoration: _backgroundDecoration,
                    width: size.width,
                    height: size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
              Container(
                color: Color(0x80000000),
              ),
              Container(
                height: Get.height,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ConstrainedBox(
                        constraints: constraints.copyWith(
                          minHeight: constraints.maxHeight,
                          maxHeight: double.infinity,
                        ),
                        child: IntrinsicHeight(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(height: constraints.maxHeight * 0.1),
                                Expanded(
                                  child: SafeArea(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Hero(
                                          tag: 'utemLogo',
                                          child: Image.asset(
                                            'assets/images/utem_logo_color_blanco.png',
                                            width: 250,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(height: constraints.maxHeight * 0.1),
                                LoginTextFormField(
                                  hintText: 'nombre@utem.cl',
                                  labelText: 'Correo UTEM',
                                  textCapitalization: TextCapitalization.none,
                                  keyboardType: TextInputType.emailAddress,
                                  icon: Icons.person,
                                  onSaved: (String value) {
                                    _correo = value;
                                  },
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Debe ingresar un correo UTEM';
                                    } else if (!value.endsWith("@utem.cl")) {
                                      return 'Debe ingresar un correo UTEM';
                                    }
                                  },
                                ),
                                LoginTextFormField(
                                  hintText: '• • • • • • • • •',
                                  labelText: 'Contraseña',
                                  textCapitalization: TextCapitalization.none,
                                  icon: Icons.lock,
                                  obscureText: true,
                                  onSaved: (String value) {
                                    _contrasenia = value;
                                  },
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Debe ingresar una contraseña';
                                    }
                                  },
                                ),
                                TextButton(
                                  onPressed: () => _login(),
                                  child: Text("Iniciar"),
                                ),
                                Container(height: constraints.maxHeight * 0.1),
                                if (!isKeyboardVisible)
                                  Expanded(
                                    child: SafeArea(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: SafeArea(
                                              child: GestureDetector(
                                                child: MarkdownBody(
                                                  selectable: false,
                                                  styleSheet:
                                                      MarkdownStyleSheet(
                                                    textAlign:
                                                        WrapAlignment.center,
                                                    p: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  data: _creditText,
                                                ),
                                                onTap: () {
                                                  Get.to(() => AcercaScreen());
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_correo == "error@utem.cl") {
        Get.dialog(
          ErrorDialog(
            contenido: Container(
              height: 100,
              child: FlareActor(
                "assets/animations/monito.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "rascarse",
              ),
            ),
            mensaje: Text(
              "Ops, parece que metimos la pata. Sólo queda esperar e intentarlo más tarde.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      } else if (_correo == "test@utem.cl" && _contrasenia == "test") {
        Get.snackbar(
          "Error",
          "Usuario o contraseña incorrecta",
          colorText: Colors.white,
          backgroundColor: Get.theme.primaryColor,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(20),
        );
      } else {
        Get.dialog(
          LoadingDialog(),
          barrierDismissible: false,
        );

        try {
          bool esPrimeraVez = await AuthService.esPrimeraVez();
          Usuario usuario =
              await AuthService.login(_correo, _contrasenia, true);

          FirebaseAnalytics.instance.logLogin();
          FirebaseAnalytics.instance.setUserId(id: usuario.correoUtem);
          if (usuario.rut != null) {
            FirebaseAnalytics.instance.setUserProperty(
                name: "rut", value: usuario.rut!.numero.toString());
          }

          Get.offAll(MainScreen(usuario: usuario));

          if (esPrimeraVez) {
            Get.dialog(
              AcercaDialog(),
            );
          }
        } on DioError catch (e) {
          print(e.message);
          Get.back();
          if (e.response?.statusCode == 403) {
            if (e.response?.data["codigoInterno"]?.toString() == "4") {
              Get.dialog(
                ErrorDialog(
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
                              Get.to(() => AcercaScreen());
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              Get.snackbar(
                "Error",
                "Usuario o contraseña incorrecta",
                colorText: Colors.white,
                backgroundColor: Get.theme.primaryColor,
                snackPosition: SnackPosition.BOTTOM,
                margin: EdgeInsets.all(20),
              );
            }
          } else if (e.response?.statusCode != null &&
              e.response!.statusCode.toString().startsWith("5")) {
            print(e.response?.data);
            Get.dialog(
              ErrorDialog(
                contenido: Container(
                  height: 200,
                  child: FlareActor(
                    "assets/animations/monito.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: "rascarse",
                  ),
                ),
                mensaje: Text(
                  "Ops, parece que metimos la pata. Sólo queda esperar e intentarlo más tarde.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          } else {
            print(e.response?.data);
            Get.snackbar(
              "Error",
              "Ocurrió un error inesperado 😢",
              colorText: Colors.white,
              backgroundColor: Get.theme.primaryColor,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.all(20),
            );
          }
        } catch (e) {
          print(e.toString());
          Get.back();
          Get.snackbar(
            "Error",
            "Ocurrió un error inesperado 😢",
            colorText: Colors.white,
            backgroundColor: Get.theme.primaryColor,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(20),
          );
        }
      }
    }
  }
}
