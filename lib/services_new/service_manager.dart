import 'package:mi_utem/services_new/implementations/asignaturas_service.dart';
import 'package:mi_utem/services_new/implementations/auth_service.dart';
import 'package:mi_utem/services_new/implementations/carreras_service.dart';
import 'package:mi_utem/services_new/implementations/controllers/calculator_controller.dart';
import 'package:mi_utem/services_new/implementations/controllers/horario_controller.dart';
import 'package:mi_utem/services_new/implementations/credential_service.dart';
import 'package:mi_utem/services_new/implementations/grades_service.dart';
import 'package:mi_utem/services_new/implementations/horario_service.dart';
import 'package:mi_utem/services_new/implementations/noticias_service.dart';
import 'package:mi_utem/services_new/implementations/qr_pass_service.dart';
import 'package:mi_utem/services_new/interfaces/asignaturas_service.dart';
import 'package:mi_utem/services_new/interfaces/auth_service.dart';
import 'package:mi_utem/services_new/interfaces/carreras_service.dart';
import 'package:mi_utem/services_new/interfaces/controllers/calculator_controller.dart';
import 'package:mi_utem/services_new/interfaces/controllers/horario_controller.dart';
import 'package:mi_utem/services_new/interfaces/credential_service.dart';
import 'package:mi_utem/services_new/interfaces/grades_service.dart';
import 'package:mi_utem/services_new/interfaces/horario_service.dart';
import 'package:mi_utem/services_new/interfaces/noticias_service.dart';
import 'package:mi_utem/services_new/interfaces/qr_pass_service.dart';
import 'package:watch_it/watch_it.dart';

Future<void> registerServices() async {
  di.registerLazySingleton<AsignaturasService>(() => AsignaturasServiceImplementation());
  di.registerLazySingleton<AuthService>(() => AuthServiceImplementation());
  di.registerLazySingleton<CarrerasService>(() => CarrerasServiceImplementation());
  di.registerLazySingleton<CredentialsService>(() => CredentialsServiceImplementation());
  di.registerLazySingleton<GradesService>(() => GradesServiceImplementation());
  di.registerLazySingleton<HorarioService>(() => HorarioServiceImplementation());
  di.registerLazySingleton<NoticiasService>(() => NoticiasServiceImplementation());
  di.registerLazySingleton<QRPassService>(() => QRPassServiceImplementation());

  /* Controladores */
  di.registerLazySingleton<HorarioController>(() => HorarioControllerImplementation());
  di.registerLazySingleton<CalculatorController>(() => CalculatorControllerImplementation());
}