import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mi_utem/config/constants.dart';
import 'package:mi_utem/config/http_client.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services_new/interfaces/auth_service.dart';
import 'package:mi_utem/services_new/interfaces/carreras_service.dart';
import 'package:watch_it/watch_it.dart';

class CarrerasServiceImplementation with ChangeNotifier implements CarrerasService {

  @override
  ValueNotifier<List<Carrera>> get carreras => ValueNotifier([]);

  ValueNotifier<Carrera?> get selectedCarrera => ValueNotifier(null);

  @override
  Future<void> getCarreras({bool forceRefresh = false}) async {
    logger.d("[CarrerasService#getCarreras]: Obteniendo carreras...");
    final user = await di.get<AuthService>().getUser();
    if(user == null) {
      logger.d("[CarrerasService#getCarreras]: No hay usuario logueado, no se pueden obtener las carreras");
      return;
    }

    final response = await AuthClient().get(Uri.parse("$apiUrl/v1/carreras"));

    final json = jsonDecode(response.body);
    logger.d("[CarrerasService#getCarreras]: Response: $json");
    if(response.statusCode != 200) {
      logger.e("Error al obtener carreras: $json}");
      if(json is Map && json.containsKey("error")) {
        throw CustomException.fromJson(json as Map<String, dynamic>);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    carreras.value = Carrera.fromJsonList(json);
    autoSelectCarreraActiva(carreras.value);
    notifyListeners();
    logger.d("[CarrerasService#getCarreras]: Carreras obtenidas: $json");
  }

  @override
  void changeSelectedCarrera(Carrera carrera) => selectedCarrera.value = carrera;

  @override
  void autoSelectCarreraActiva(List<Carrera> carreras) {
    final estados = ["Regular", "Causal de Eliminacion"]
        .reversed
        .map((e) => e.toLowerCase())
        .toList();

    carreras.sort((a,b) => estados.indexOf(b.estado!.toLowerCase()).compareTo(estados.indexOf(a.estado!.toLowerCase())));
    final carreraActiva = carreras.first;

    AnalyticsService.setCarreraToUser(carreraActiva);
    changeSelectedCarrera(carreraActiva);
  }

}