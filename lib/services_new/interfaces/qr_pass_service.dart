import 'package:mi_utem/models/permiso_covid.dart';

abstract class QRPassService {

  Future<List<PermisoCovid>?> getPermisos({bool forceRefresh = false});

  Future<PermisoCovid?> getDetallesPermiso(String id, {bool forceRefresh = false});
}