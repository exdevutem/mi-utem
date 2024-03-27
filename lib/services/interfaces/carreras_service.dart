import 'package:mi_utem/models/carrera.dart';

abstract class CarrerasService {

  abstract List<Carrera> carreras;
  abstract Carrera? selectedCarrera;

  Future<void> getCarreras();

  void changeSelectedCarrera(Carrera carrera);

  void autoSelectCarreraActiva();

}