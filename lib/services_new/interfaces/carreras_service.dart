import 'package:flutter/material.dart';
import 'package:mi_utem/models/carrera.dart';

abstract class CarrerasService {

  abstract ValueNotifier<List<Carrera>> carreras;
  abstract ValueNotifier<Carrera?> selectedCarrera;

  Future<void> getCarreras({bool forceRefresh = false});

  void changeSelectedCarrera(Carrera carrera);

  void autoSelectCarreraActiva();

}