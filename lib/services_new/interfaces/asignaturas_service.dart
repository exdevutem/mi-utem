import 'package:mi_utem/models/asignatura.dart';

abstract class AsignaturasService {

  Future<List<Asignatura>?> getAsignaturas(String? carreraId, {bool forceRefresh = false});

  Future<Asignatura?> getDetalleAsignatura(String? asignaturaId, {bool forceRefresh = false});
}