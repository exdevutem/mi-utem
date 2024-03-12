import 'package:mi_utem/models/horario.dart';

abstract class HorarioService {

  Future<Horario?> getHorario(String carreraId, {bool forceRefresh = false});
}