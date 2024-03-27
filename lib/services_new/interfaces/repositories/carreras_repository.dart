import 'package:mi_utem/models/carrera.dart';

abstract class CarrerasRepository {

  /* Obtiene las carreras */
  Future<List<Carrera>> getCarreras();
}