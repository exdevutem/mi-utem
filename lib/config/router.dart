import 'dart:developer';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/screens/asignatura_screen.dart';
import 'package:mi_utem/screens/asignaturas_screen.dart';
import 'package:mi_utem/screens/calculadora_notas_screen.dart';
import 'package:mi_utem/screens/credencial_screen.dart';
import 'package:mi_utem/screens/horario_screen.dart';
import 'package:mi_utem/screens/login_screen/login_screen.dart';
import 'package:mi_utem/screens/main_screen.dart';
import 'package:mi_utem/screens/splash_screen.dart';
import 'package:mi_utem/screens/usuario_screen.dart';
import 'package:mi_utem/services/auth_service.dart';
import 'package:mi_utem/services/perfil_service.dart';
import 'package:mi_utem/widgets/acerca_screen.dart';

/* BeamPage? _dialogBuilder(BuildContext context, BeamState state) {
  if (state.queryParameters.containsKey('loading'))
    return BeamPage(
      routeBuilder: (context, settings, child) => DialogRoute<void>(
        context: context,
        builder: (context) => child,
        settings: settings,
      ),
      key: ValueKey('book-buy-${state.pathParameters['bookId']}'),
      onPopPage: (context, delegate, routeInfo, page) {
        // when the dialog is dismissed, we only want to pop the `buy=true` query parameter
        // instead of also popping the bookId.
        delegate.currentBeamLocation.update(
          (state) => state.routeInformation.state = state.routeInformation.state
            ..remove('loading'),
        );
        return true;
      },
      child: LoadingDialog(),
    );
  return null;
} */

final routerDelegate = BeamerDelegate(
  initialPath: '/splash',
  locationBuilder: RoutesLocationBuilder(
    routes: {
      '/splash': (context, state, data) => SplashScreen(),
      '/acerca': (context, state, data) => AcercaScreen(),
      '/login': (context, state, data) => LoginScreen(),
      '/': (context, state, data) {
        final usuario = PerfilService.getLocalUsuario();

        return MainScreen(usuario: usuario);
      },
      '/perfil': (context, state, data) => UsuarioScreen(),
      '/credencial': (context, state, data) => CredencialScreen(),
      '/calculadora-notas': (context, state, data) {
        final asignatura = data as Asignatura?;

        return CalculadoraNotasScreen(
          asignaturaInicial: asignatura,
        );
      },
      '/horario': (context, state, data) {
        return BeamPage(
          key: ValueKey('horario'),
          title: 'Horario',
          popToNamed: '/',
          type: BeamPageType.scaleTransition,
          child: HorarioScreen(),
        );
      },
/*       '/carreras/:carreraId/horario': (context, state, data) {
        final carreraId = state.pathParameters['carreraId']!;

        return BeamPage(
          key: ValueKey('horario-$carreraId'),
          title: 'Horario $carreraId',
          popToNamed: '/',
          type: BeamPageType.scaleTransition,
          child: HorarioScreen(carreraId: carreraId),
        );
      }, */
      '/asignaturas': (context, state, data) {
        return BeamPage(
          key: ValueKey('asignaturas'),
          title: 'Asignaturas',
          popToNamed: '/',
          type: BeamPageType.scaleTransition,
          child: AsignaturasScreen(),
        );
      },
/*       '/carreras/:carreraId/asignaturas': (context, state, data) {
        final carreraId = state.pathParameters['carreraId']!;

        return BeamPage(
          key: ValueKey('asignaturas-$carreraId'),
          title: 'Asignaturas $carreraId',
          popToNamed: '/',
          type: BeamPageType.scaleTransition,
          child: AsignaturasScreen(carreraId: carreraId),
        );
      } */
      '/asignatura': (context, state, data) {
        if (data == null) return null;
        final asignatura = data as Asignatura;

        return BeamPage(
          key: ValueKey('asignatura'),
          title: 'Asignaturas',
          popToNamed: '/',
          type: BeamPageType.scaleTransition,
          child: AsignaturaScreen(asignatura: asignatura),
        );
      },
    },
  ),
  guards: [
    BeamGuard(
      pathPatterns: ['/splash', '/login', '/acerca'],
      guardNonMatching: true,
      check: (context, location) => AuthService.isLoggedIn(),
      onCheckFailed: (context, location) =>
          log('guardNonMatching: true onCheckFailed'),
      beamToNamed: (origin, target) => '/login',
    ),
    BeamGuard(
      pathPatterns: ['/splash', '/login', '/acerca'],
      check: (context, location) => !AuthService.isLoggedIn(),
      onCheckFailed: (context, location) =>
          log('guardNonMatching: false onCheckFailed'),
      beamToNamed: (origin, target) => '/',
    )
  ],
);

/* final router = GoRouter(
  navigatorKey: Get.key,
  debugLogDiagnostics: true,
  initialLocation: "/",
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    /* GoRoute(
      path: '/carreras/:carreraId/asignaturas',
      builder: (context, state) => AsignaturasScreen(
        carreraId: state.params['carreraId'],
      ),
    ),
    GoRoute(
      path: '/carreras/:carreraId/asignaturas/:asignaturaId',
      builder: (context, state) => AsignaturaScreen(),
    ), */
  ],
  redirect: (context, state) async {
    final isLoggedIn = await AuthService.isLoggedIn();

    if (!isLoggedIn) return '/login';

    return null;
  },
); */
