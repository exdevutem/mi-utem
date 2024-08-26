import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/core/services/auth_service.dart';
import 'package:mi_utem/core/utils/constants.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/models/preferencia.dart';
import 'package:mi_utem/models/user/credential.dart';
import 'package:mi_utem/repositories/credentials_repository.dart';
import 'package:mi_utem/screens/main_screen.dart';
import 'package:mi_utem/screens/onboarding/welcome_screen.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/widgets/acerca/dialog/acerca_dialog.dart';
import 'package:mi_utem/widgets/dialogs/monkey_error_dialog.dart';
import 'package:mi_utem/widgets/loading/loading_dialog.dart';
import 'package:mi_utem/widgets/snackbar.dart';

Future<void> login({
  required BuildContext context,
  required TextEditingController correoController,
  required TextEditingController contraseniaController,
  required GlobalKey<FormState> formKey,
}) async {
  final AuthService authService = Get.find<AuthService>();
  final CredentialsRepository credentialsService = Get.find<CredentialsRepository>();
  final correo = correoController.text;
  final contrasenia = contraseniaController.text;

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

  if(formKey.currentState?.validate() == false) {
    return;
  }

  showLoadingDialog(context);

  try {
    await credentialsService.setCredentials(Credentials(
      email: correo,
      password: contrasenia,
    ));

    if(!(await credentialsService.hasCredentials())) {
      showTextSnackbar(context,
        title: "Error",
        message: "Ha ocurrido un error al guardar tus claves. Intenta más tarde.",
      );
      return;
    }

    try {
      await authService.login();
    } on CustomException catch (e) {
      logger.e(e);
      Navigator.pop(context);
      showTextSnackbar(context,
        title: "Error",
        message: e.message,
      );
      return;
    } catch (e) {
      logger.e(e);
      Navigator.pop(context);
      showTextSnackbar(context,
        title: "Error",
        message: "Ha ocurrido un error desconocido. Por favor intenta más tarde.",
      );
      return;
    }

    final isFirstTime = await authService.isFirstTime();
    final user = await authService.getUser();
    if(user == null) {
      Navigator.pop(context);
      showTextSnackbar(context,
        title: "Error",
        message: "Ha ocurrido un error desconocido. Por favor intenta más tarde.",
      );
      return;
    }

    AnalyticsService.logEvent('login');

    Navigator.of(context).popUntil((route) => route.isFirst); // Esto elimina todas las pantallas anteriores
    // Y esto reemplaza la pantalla actual por la nueva, cosa de que no pueda "volver" al login a menos que cierre la sesión.
    final hasCompletedOnboarding = (await Preferencia.onboardingStep.get()) == 'complete';
    if(hasCompletedOnboarding) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
      if(isFirstTime) {
        showDialog(context: context, builder: (ctx) => AcercaDialog());
      }
      return;
    }

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WelcomeScreen()));
  } on CustomException catch (e) {
    logger.e(e);
    Navigator.pop(context);
    showTextSnackbar(context,
      title: "Error",
      message: e.message,
    );
  }  on DioError catch (e) {
    Navigator.pop(context);
    showTextSnackbar(context,
      title: "Error",
      message: (e.error as CustomException).message,
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