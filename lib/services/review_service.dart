import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mi_utem/models/rut.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';
import 'package:mi_utem/widgets/custom_alert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {
  static final Duration minRequest = Duration(days: 80);

  static final Duration minScreen = Duration(days: 3);
  static final Duration maxScreen = Duration(days: 7);

  static final InAppReview inAppReview = InAppReview.instance;
  static final List<String> screens = [
    "MainScreen",
    "CredencialScreen",
    "UsuarioScreen",
    "CalculadoraNotasScreen",
    "HorarioScreen",
    "AsignaturaScreen"
  ];

  static Future<bool> addScreen(String screenName) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (screens.contains(screenName)) {
        prefs.setString("review$screenName", DateTime.now().toIso8601String());
        return true;
      } else {
        print(
            "ERROR ReviewService addScreen: no estaba contemplada esta pantalla");
        return false;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<bool> mustRequest() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      for (String screen in screens) {
        String? isoDate = prefs.getString("review$screen");
        if (isoDate != null && isoDate.isNotEmpty) {
          DateTime date = DateTime.parse(isoDate);
          DateTime maxDate = DateTime.now().subtract(maxScreen);
          DateTime minDate = DateTime.now().subtract(minScreen);
          if (date.isBefore(maxDate) || date.isAfter(minDate)) {
            print(
                "ReviewService mustRequest: $screen no cumple con una fecha $isoDate");
            return false;
          }
        } else {
          print("ReviewService mustRequest: $screen no se ha visitado");
          return false;
        }
      }
      String? lastRequestIsoDate = prefs.getString("reviewLastRequest");
      if (lastRequestIsoDate != null && lastRequestIsoDate.isNotEmpty) {
        DateTime lastRequestDate = DateTime.parse(lastRequestIsoDate);
        DateTime minDate = DateTime.now().subtract(minRequest);
        if (lastRequestDate.isAfter(minDate)) {
          print(
              "ReviewService mustRequest: no ha pasado el minimo desde la ultima request $lastRequestIsoDate");
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<void> checkAndRequestReview() async {
    try {
      print("ReviewService checkAndRequestReview");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool mustRequest = await ReviewService.mustRequest();
      if (mustRequest) {
        if (await inAppReview.isAvailable()) {
          await Get.dialog(
            CustomAlertDialog(
              titulo: "¿Te gustaría calificar a Mi UTEM?",
              emoji: "⭐",
              descripcion:
                  "Te invitamos a dejarnos tus comentarios y estrellitas",
              onCancelar: () async {
                Get.back();
              },
              onConfirmar: () async {
                await inAppReview.requestReview();
                prefs.setString(
                    "reviewLastRequest", DateTime.now().toIso8601String());
                Get.back();
              },
              cancelarTextoBoton: "No, gracias 😡",
              confirmarTextoBoton: "Dejar estrellitas 😊",
            ),
          );
        } else {
          print(
              "ReviewService checkAndRequestReview: inAppReview no está disponible");
        }
      } else {
        print("ReviewService checkAndRequestReview: mustRequest es false");
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
