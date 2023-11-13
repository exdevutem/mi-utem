import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:mi_utem/config/routes.dart';
import 'package:mi_utem/helpers/snackbars.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services/auth_service.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:mi_utem/widgets/acerca/acerca_dialog.dart';
import 'package:mi_utem/widgets/dialogs/monkey_error_dialog.dart';
import 'package:mi_utem/widgets/dialogs/not_ready_dialog.dart';
import 'package:mi_utem/widgets/loading_dialog.dart';
import 'package:mi_utem/widgets/login_text_form_field.dart';
import 'package:video_player/video_player.dart';

part '_background.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _correoController = TextEditingController();
  TextEditingController _contraseniaController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _correoController.text = "";
    _contraseniaController.text = "";

    SchedulerBinding.instance.addPostFrameCallback((_) {
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
    List<dynamic> texts = jsonDecode(RemoteConfigService.creditos);

    Random random = new Random();

    return texts[random.nextInt(texts.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return _Background(
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                            AutofillGroup(
                              child: Column(
                                children: [
                                  LoginTextFormField(
                                    controller: _correoController,
                                    hintText: 'nombre@utem.cl',
                                    labelText: 'Correo UTEM',
                                    textCapitalization: TextCapitalization.none,
                                    keyboardType: TextInputType.emailAddress,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp(" ")),
                                    ],
                                    icon: Icons.person,
                                    autofillHints: [AutofillHints.username],
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Debe ingresar un correo UTEM';
                                      } else if (value.contains("@") &&
                                          !value.endsWith("@utem.cl")) {
                                        return 'Debe ingresar un correo UTEM';
                                      }
                                    },
                                  ),
                                  LoginTextFormField(
                                    controller: _contraseniaController,
                                    hintText: '• • • • • • • • •',
                                    labelText: 'Contraseña',
                                    textCapitalization: TextCapitalization.none,
                                    icon: Icons.lock,
                                    obscureText: true,
                                    autofillHints: [AutofillHints.password],
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Debe ingresar una contraseña';
                                      }
                                    },
                                  )
                                ],
                              ),
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
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: SafeArea(
                                          child: GestureDetector(
                                            child: MarkdownBody(
                                              selectable: false,
                                              styleSheet: MarkdownStyleSheet(
                                                textAlign: WrapAlignment.center,
                                                p: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              data: _creditText,
                                            ),
                                            onTap: () {
                                              Get.toNamed(
                                                Routes.about,
                                              );
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
          );
        },
      ),
    );
  }

  Future<void> _login() async {
    final correo = _correoController.text;
    final contrasenia = _contraseniaController.text;

    if (correo == "error@utem.cl") {
      Get.dialog(MonkeyErrorDialog());
    } else if (correo == "test@utem.cl" && contrasenia == "test") {
      showDefaultSnackbar(
        "Error",
        "Usuario o contraseña incorrecta",
      );
    } else {
      if (_formKey.currentState?.validate() ?? false) {
        Get.dialog(
          LoadingDialog(),
          barrierDismissible: false,
        );

        try {
          bool esPrimeraVez = await AuthService.esPrimeraVez();
          Usuario usuario = await AuthService.login(correo, contrasenia, true);

          AnalyticsService.logEvent('login');
          AnalyticsService.setUser(usuario);

          Get.toNamed(
            Routes.home,
          );

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
              Get.dialog(NotReadyDialog());
            } else {
              showDefaultSnackbar(
                "Error",
                "Usuario o contraseña incorrecta",
              );
            }
          } else if (e.response?.statusCode != null &&
              e.response!.statusCode.toString().startsWith("5")) {
            print(e.response?.data);
            Get.dialog(MonkeyErrorDialog());
          } else {
            print(e.response?.data);
            showDefaultSnackbar(
              "Error",
              "Ocurrió un error inesperado 😢",
            );
          }
        } catch (e) {
          print(e.toString());
          Get.back();
          showDefaultSnackbar(
            "Error",
            "Ocurrió un error inesperado 😢",
          );
        }
      }
    }
  }
}
