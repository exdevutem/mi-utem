import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/core/models/user/user.dart';
import 'package:mi_utem/core/services/auth_service.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/models/pair.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services/carreras_service.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/widgets/credencial/credencial_card.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/flip_widget.dart';
import 'package:mi_utem/widgets/loading/loading_indicator.dart';
import 'package:screen_protector/screen_protector.dart';

class CredencialScreen extends StatefulWidget {
  const CredencialScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CredencialScreenState();
}

class _CredencialScreenState extends State<CredencialScreen> {
  final FlipController _flipController = FlipController();

  @override
  void initState() {
    ReviewService.addScreen("CredencialScreen");
    // Set device orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ScreenProtector.preventScreenshotOn();
    ScreenProtector.protectDataLeakageOn();
    ScreenProtector.protectDataLeakageWithBlur();
    super.initState();
  }

  @override
  void dispose() {
    ScreenProtector.preventScreenshotOff();
    ScreenProtector.protectDataLeakageOff();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppBar(
      title: const Text("Credencial universitaria"),
      actions: [
        IconButton(
          icon: Icon(_flipController.actualFace == FlipController.front ? Icons.info : Mdi.accountCircle),
          onPressed: _flipController.flip?.call(),
        ),
      ],
    ),
    backgroundColor: Colors.grey[200],
    body: FutureBuilder<Pair<User?, Carrera?>>(
      future: () async {
        final authService = Get.find<AuthService>();
        final carrerasService = Get.find<CarrerasService>();

        final user = await authService.getUser();
        final carrera = await carrerasService.getCarreras();

        return Pair(user, carrera);
      }(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CustomErrorWidget(
            title: "Ocurrió un error al generar tu credencial",
            error: snapshot.error,
          );
        }

        final pair = snapshot.data;
        final user = pair?.a;
        final carreraActiva = pair?.b;

        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: LoadingIndicator.centered(),
                ),
              ],
            ),
          );
        }

        if (user == null || carreraActiva == null || carreraActiva.nombre == null) {
          return CustomErrorWidget(
            title: "Ocurrió un error al generar tu credencial. Por favor, intenta nuevamente.",
            error: snapshot.error,
          );
        }

        if (carreraActiva.nombre?.isNotEmpty == true) {
          return Center(
            child: SafeArea(
              child: CredencialCard(
                user: user,
                carrera: carreraActiva,
                controller: _flipController,
                onFlip: (_) {
                  AnalyticsService.logEvent("credencial_flip");
                  setState(() {});
                },
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("😕",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 15),
              const Text("Ocurrió un error al generar tu credencial",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 15),
              Text(snapshot.error.toString(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    ),
  );
}
