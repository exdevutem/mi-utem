
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/core/services/auth_service.dart';
import 'package:mi_utem/models/preferencia.dart';
import 'package:mi_utem/screens/login_screen/login_screen.dart';
import 'package:mi_utem/screens/main_screen.dart';
import 'package:mi_utem/screens/onboarding/welcome_screen.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/utils/http/functions.dart';
import 'package:mi_utem/widgets/loading/loading_dialog.dart';
import 'package:mi_utem/widgets/snackbar.dart';

void splashAction({ required BuildContext context }) async {
  AuthService authService = Get.find<AuthService>();
  showLoadingDialog(context);

  // Revisar si tenemos conexión a internet
  bool offlineMode = await isOffline();
  final user = await authService.getUser();

  if(offlineMode) {
    Navigator.pop(context);
    showTextSnackbar(context,
      title: "Error al conectar con la API",
      message: user != null ? "La app funcionará en modo Offline. Revisa tu conexión a internet si quieres acceder a todas las funcionalidades." : "Ouch! Parece que no tienes una conexión a internet. Revisa tu conexión e intenta más tarde.",
      backgroundColor: Colors.red,
      duration: Duration(seconds: 20),
    );

    if(user == null) {
      return;
    }
  }

  final isLoggedIn = (await authService.getUser()) != null;
  AnalyticsService.removeUser();

  // Esto nos asegura de que el splash es la única ruta inicial, y resuelve el error de poder volver al login.
  Navigator.popUntil(context, (route) => route.isFirst);

  final hasCompletedOnboarding = (await Preferencia.onboardingStep.get()) == "complete";
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => isLoggedIn ? (hasCompletedOnboarding ? MainScreen() : WelcomeScreen()) : LoginScreen()));
}