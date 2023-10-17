import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mi_utem/config/routes/routes.dart';
import 'package:mi_utem/controllers/asignaturas_controller.dart';
import 'package:mi_utem/controllers/qr_passes_controller.dart';
import 'package:mi_utem/controllers/user_controller.dart';
import 'package:mi_utem/screens/asignatura/asignatura_detalle_screen.dart';
import 'package:mi_utem/screens/asignatura/asignaturas_lista_screen.dart';
import 'package:mi_utem/screens/calculadora_notas_screen.dart';
import 'package:mi_utem/screens/credencial_screen.dart';
import 'package:mi_utem/screens/horario/horario_screen.dart';
import 'package:mi_utem/screens/login_screen/login_screen.dart';
import 'package:mi_utem/screens/main/main_screen.dart';
import 'package:mi_utem/screens/permiso_covid_screen.dart';
import 'package:mi_utem/screens/splash_screen.dart';
import 'package:mi_utem/screens/usuario_screen.dart';
import 'package:mi_utem/widgets/acerca_screen.dart';

final _loginPage = GetPage(
  name: Routes.login,
  page: () => LoginScreen(),
  middlewares: [OnlyNoAuthMiddleware()],
);

final _homePage = GetPage(
  name: Routes.home,
  bindings: [QrPassesBinding()],
  page: () => MainScreen(),
  middlewares: [OnlyAuthMiddleware()],
);

final pages = <GetPage>[
  GetPage(
    name: Routes.splash,
    page: () => SplashScreen(),
  ),
  GetPage(
    name: Routes.about,
    page: () => AcercaScreen(),
  ),
  _loginPage,
  _homePage,
  GetPage(
    name: Routes.perfil,
    page: () => UsuarioScreen(),
    middlewares: [OnlyAuthMiddleware()],
  ),
  GetPage(
    name: Routes.credencial,
    page: () => CredencialScreen(),
    middlewares: [OnlyAuthMiddleware()],
  ),
  GetPage(
    name: Routes.calculadoraNotas,
    page: () => CalculadoraNotasScreen(),
    middlewares: [OnlyAuthMiddleware()],
  ),
  GetPage(
    name: Routes.horario,
    page: () => HorarioScreen(),
    binding: HorarioBinding(),
    middlewares: [OnlyAuthMiddleware()],
  ),
  GetPage(
    name: Routes.asignaturas,
    page: () => AsignaturasListaScreen(),
    middlewares: [OnlyAuthMiddleware()],
    binding: AsignaturasBinding(),
  ),
  GetPage(
    name: '${Routes.asignatura}/:asignaturaId',
    page: () => AsignaturaDetalleScreen(),
  ),
  GetPage(
    name: Routes.pass,
    page: () => PermisoCovidScreen(),
    middlewares: [OnlyAuthMiddleware()],
  ),
];

class OnlyAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? page) {
    final isLoggedIn = UserController.to.isLoggedIn;
    if (!isLoggedIn) {
      return const RouteSettings(name: Routes.login);
    }
    return null;
  }
}

class OnlyNoAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? page) {
    final isLoggedIn = UserController.to.isLoggedIn;
    if (isLoggedIn) {
      return const RouteSettings(name: Routes.home);
    }
    return null;
  }
}
