import 'package:flutter/material.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/models/user/credential.dart';
import 'package:mi_utem/screens/main_screen.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services_new/interfaces/auth_service.dart' as NewAuthService;
import 'package:mi_utem/services_new/interfaces/credential_service.dart';
import 'package:mi_utem/widgets/acerca/dialog/acerca_dialog.dart';
import 'package:mi_utem/widgets/dialogs/monkey_error_dialog.dart';
import 'package:mi_utem/widgets/loading_dialog.dart';
import 'package:mi_utem/widgets/snackbar.dart';
import 'package:watch_it/watch_it.dart';


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

  final _authService = di.get<NewAuthService.AuthService>();
  final _credentialsService = di.get<CredentialsService>();

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: () => _login(context),
    child: Text("Iniciar"),
  );

  Future<void> _login(BuildContext context) async {
    final correo = widget._correoController.text;
    final contrasenia = widget._contraseniaController.text;

    if (correo == "error@utem.cl") {
      showDialog(context: context, builder: (ctx) => MonkeyErrorDialog());
      return;
    } else if (correo == "test@utem.cl" && contrasenia == "test") {
      showTextSnackbar(context,
        title: "Error",
        message: "Usuario o contraseña incorrecta",
      );
      return;
    }

    if(widget._formKey.currentState?.validate() == false) {
      return;
    }

    showLoadingDialog(context);

    try {
      await _credentialsService.setCredentials(Credentials(
        email: correo,
        password: contrasenia,
      ));

      if(!(await _credentialsService.hasCredentials())) {
        showTextSnackbar(context,
          title: "Error",
          message: "Ha ocurrido un error al guardar tus claves. Intenta más tarde.",
        );
        return;
      }

      await _authService.login();

      try {
        final isFirstTime = await _authService.isFirstTime();
        final user = await _authService.getUser();
        if(user == null) {
          Navigator.pop(context);
          showTextSnackbar(context,
            title: "Error",
            message: "Ha ocurrido un error desconocido. Por favor intenta más tarde.",
          );
          return;
        }

        AnalyticsService.logEvent('login');
        AnalyticsService.setUser(user);

        Navigator.of(context).popUntil((route) => route.isFirst); // Esto elimina todas las pantallas anteriores
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen())); // Y esto reemplaza la pantalla actual por la nueva, cosa de que no pueda "volver" al login a menos que cierre la sesión.

        if(isFirstTime) {
          showDialog(context: context, builder: (ctx) => AcercaDialog());
        }
      } catch (e) {
        logger.e(e);
        Navigator.pop(context);
        showTextSnackbar(context,
          title: "Error",
          message: "Ha ocurrido un error desconocido. Por favor intenta más tarde.",
        );
      }
      return;
    } on CustomException catch (e) {
      logger.e(e);
      Navigator.pop(context);
      showTextSnackbar(context,
        title: "Error",
        message: e.message,
      );
    } catch (e) {
      logger.e(e);
      Navigator.pop(context);
      showTextSnackbar(context,
        title: "Error",
        message: "Ha ocurrido un error desconocido. Por favor intenta más tarde.",
      );
    }
  }
}