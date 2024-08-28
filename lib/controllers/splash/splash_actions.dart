
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/core/models/preferencia.dart';
import 'package:mi_utem/core/repositories/secure_storage_repository.dart';
import 'package:mi_utem/core/utils/http/functions.dart';
import 'package:mi_utem/screens/login_screen/login_screen.dart';
import 'package:mi_utem/screens/main_screen.dart';
import 'package:mi_utem/screens/onboarding/welcome_screen.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/widgets/loading/loading_dialog.dart';
import 'package:mi_utem/widgets/snackbar.dart';

void splashAction({ required BuildContext context }) async {
  SecureStorageRepository secureStorageRepository = Get.find<SecureStorageRepository>();
  showLoadingDialog(context);

  // Revisar si tenemos conexión a internet
  bool offlineMode = await isOffline();
  final estudiante = await secureStorageRepository.getEstudiante();

  if(offlineMode) {
    Navigator.pop(context);
    showTextSnackbar(context,
      title: "Error al conectar con la API",
      message: estudiante != null ? "La app funcionará en modo Offline. Revisa tu conexión a internet si quieres acceder a todas las funcionalidades." : "Ouch! Parece que no tienes una conexión a internet. Revisa tu conexión e intenta más tarde.",
      backgroundColor: Colors.red,
      duration: Duration(seconds: 20),
    );

    if(estudiante == null) {
      return;
    }
  }

  AnalyticsService.removeUser();

  // Esto nos asegura de que el splash es la única ruta inicial, y resuelve el error de poder volver al login.
  Navigator.popUntil(context, (route) => route.isFirst);

  final hasCompletedOnboarding = (await Preferencia.onboardingStep.get()) == "complete";
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => estudiante != null ? (hasCompletedOnboarding ? MainScreen() : WelcomeScreen()) : LoginScreen()));
}