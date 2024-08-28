import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/core/models/exceptions/custom_exception.dart';
import 'package:mi_utem/core/models/preferencia.dart';
import 'package:mi_utem/core/models/user/credential.dart';
import 'package:mi_utem/core/repositories/secure_storage_repository.dart';
import 'package:mi_utem/core/services/auth_service.dart';
import 'package:mi_utem/core/utils/constants.dart';
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
  final SecureStorageRepository secureStorageRepository = Get.find<SecureStorageRepository>();
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
    await secureStorageRepository.setCredentials(Credentials(
      username: correo,
      password: contrasenia,
    ));

    if(!(await secureStorageRepository.hasCredentials())) {
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
    try {
      await authService.login(forceRefresh: true);
    } on CustomException catch(e) {
      Navigator.pop(context);
      showTextSnackbar(context,
        title: "Error",
        message: e.message,
      );
      return;
    } catch (e) {
      logger.e("Error al obtener usuario", [e]);
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