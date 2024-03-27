import 'package:mi_utem/models/asignaturas/asignatura.dart';

abstract class AsignaturasRepository {

  /* Obtiene las asignaturas */
  Future<List<Asignatura>?> getAsignaturas(String? carreraId, {bool forceRefresh = false});

  /* Obtiene el detalle de una asignatura */
  Future<Asignatura?> getDetalleAsignatura(String? asignaturaId, {bool forceRefresh = false});
}