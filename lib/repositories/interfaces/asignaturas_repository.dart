import 'package:mi_utem/models/asignaturas/asignatura.dart';

abstract class AsignaturasRepository {

  /* Obtiene las asignaturas */
  Future<List<Asignatura>?> getAsignaturas(String? carreraId, {bool forceRefresh = false});

  /* Obtiene los detalles faltantes de la asignatura */
  Future<Asignatura?> getDetalleAsignatura(Asignatura? asignatura, {bool forceRefresh = false});
}