import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/config/routes.dart';
import 'package:mi_utem/helpers/snackbars.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services/auth_service.dart';
import 'package:mi_utem/widgets/acerca/dialog/acerca_dialog.dart';
import 'package:mi_utem/widgets/dialogs/monkey_error_dialog.dart';
import 'package:mi_utem/widgets/dialogs/not_ready_dialog.dart';
import 'package:mi_utem/widgets/loading_dialog.dart';


class LoginButton extends StatefulWidget {

  final TextEditingController _correoController;
  final TextEditingController _contraseniaController;

  final GlobalKey<FormState> _formKey;

  LoginButton({
    required TextEditingController correoController,
    required TextEditingController contraseniaController,
    required GlobalKey<FormState> formKey,
  }) :
    _correoController = correoController,
    _contraseniaController = contraseniaController,
    _formKey = formKey;

  @override
  _LoginButtonState createState() => _LoginButtonState();

}

class _LoginButtonState extends State<LoginButton> {

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _login(),
      child: Text("Iniciar"),
    );
  }

  Future<void> _login() async {
    final correo = widget._correoController.text;
    final contrasenia = widget._contraseniaController.text;

    if (correo == "error@utem.cl") {
      Get.dialog(MonkeyErrorDialog());
      return;
    } else if (correo == "test@utem.cl" && contrasenia == "test") {
      showDefaultSnackbar("Error", "Usuario o contraseña incorrecta");
      return;
    }

    if(widget._formKey.currentState?.validate() == false) {
      return;
    }

    Get.dialog(LoadingDialog(), barrierDismissible: false);

    try {
      bool esPrimeraVez = await AuthService.esPrimeraVez();
      Usuario usuario = await AuthService.login(correo, contrasenia, true);

      AnalyticsService.logEvent('login');
      AnalyticsService.setUser(usuario);

      Get.toNamed(Routes.home);

      if (esPrimeraVez) {
        Get.dialog(AcercaDialog());
      }
    } on DioError catch (e) {
      print(e.message);
      Get.back();
      if (e.response?.statusCode == 403) {
        if (e.response?.data["codigoInterno"]?.toString() == "4") {
          Get.dialog(NotReadyDialog());
        } else {
          showDefaultSnackbar("Error", "Usuario o contraseña incorrecta");
        }
      } else if (e.response?.statusCode != null && e.response!.statusCode.toString().startsWith("5")) {
        print(e.response?.data);
        Get.dialog(MonkeyErrorDialog());
      } else {
        print(e.response?.data);
        showDefaultSnackbar("Error", "Ocurrió un error inesperado 😢");
      }
    } catch (e) {
      print(e.toString());
      Get.back();
      showDefaultSnackbar("Error", "Ocurrió un error inesperado 😢");
    }
  }
}