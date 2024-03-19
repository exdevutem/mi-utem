import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:mi_utem/config/constants.dart';
import 'package:mi_utem/config/http_clients/auth_client.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services_new/interfaces/auth_service.dart';
import 'package:mi_utem/services_new/interfaces/carreras_service.dart';
import 'package:watch_it/watch_it.dart';

class CarrerasServiceImplementation extends ChangeNotifier implements CarrerasService {

  @override
  ValueNotifier<List<Carrera>> carreras = ValueNotifier([]);

  @override
  ValueNotifier<Carrera?> selectedCarrera = ValueNotifier(null);

  @override
  Future<void> getCarreras({bool forceRefresh = false}) async {
    logger.d("[CarrerasService#getCarreras]: Obteniendo carreras...");
    final user = await di.get<AuthService>().getUser();
    if(user == null) {
      logger.d("[CarrerasService#getCarreras]: No hay usuario logueado, no se pueden obtener las carreras");
      return;
    }

    final response = await authClient.get(Uri.parse("$apiUrl/v1/carreras"));

    final json = jsonDecode(response.body);
    if(response.statusCode != 200) {
      logger.e("Error al obtener carreras: $json}");
      if(json is Map && json.containsKey("error")) {
        throw CustomException.fromJson(json as Map<String, dynamic>);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    carreras.value = Carrera.fromJsonList(json);
    autoSelectCarreraActiva();
    notifyListeners();
  }

  @override
  void changeSelectedCarrera(Carrera carrera) => selectedCarrera.value = carrera;

  @override
  void autoSelectCarreraActiva() {
    logger.d("[CarrerasService#autoSelectCarreraActiva]: Seleccionando carrera activa... ${carreras.value.map((e) => e.toJson()).toList()}");
    final estados = ["Regular", "Causal de Eliminacion"]
        .reversed
        .map((e) => e.toLowerCase())
        .toList();

    logger.d("[CarrerasService#autoSelectCarreraActiva]: Estados: $estados");
    carreras.value.sort((a,b) => estados.indexOf(b.estado!.toLowerCase()).compareTo(estados.indexOf(a.estado!.toLowerCase())));
    logger.d("[CarrerasService#autoSelectCarreraActiva]: Carreras ordenadas: ${carreras.value.map((e) => e.toJson()).toList()}");
    final carreraActiva = carreras.value.first;

    AnalyticsService.setCarreraToUser(carreraActiva);
    changeSelectedCarrera(carreraActiva);
  }

}