import 'package:mi_utem/models/horario.dart';

abstract class HorarioRepository {

  Future<Horario?> getHorario(String carreraId, {bool forceRefresh = false});
}