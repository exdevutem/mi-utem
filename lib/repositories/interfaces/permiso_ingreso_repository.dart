import 'package:mi_utem/models/permiso_ingreso.dart';

abstract class PermisoIngresoRepository {

  Future<PermisoIngreso> getDetallesPermiso(String id);
  
  Future<List<PermisoIngreso>> getPermisos();
}