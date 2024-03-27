import 'package:flutter/material.dart';
import 'package:listenable_collections/listenable_collections.dart';
import 'package:mi_utem/models/carrera.dart';

abstract class CarrerasService {

  abstract ListNotifier<Carrera> carreras;
  abstract ValueNotifier<Carrera?> selectedCarrera;

  Future<void> getCarreras();

  void changeSelectedCarrera(Carrera carrera);

  void autoSelectCarreraActiva();

}