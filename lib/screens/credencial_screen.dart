import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/models/user/user.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/services_new/interfaces/auth_service.dart';
import 'package:mi_utem/services_new/interfaces/carreras_service.dart';
import 'package:mi_utem/widgets/credencial_card.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/flip_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:watch_it/watch_it.dart';

class CredencialScreen extends StatefulWidget with WatchItStatefulWidgetMixin {
  CredencialScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CredencialScreenState();
}

class _CredencialScreenState extends State<CredencialScreen> {
  FlipController _flipController = FlipController();

  @override
  void initState() {
    ReviewService.addScreen("CredencialScreen");
    _secureScreen();
    super.initState();
  }

  Future<void> _secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> _desecureScreen() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void dispose() {
    _desecureScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Carrera? carreraActiva = watchValue((CarrerasService service) => service.selectedCarrera);

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text("Credencial universitaria"),
        actions: [
          IconButton(
            icon: Icon(_flipController.actualFace == FlipController.front ? Icons.info : Mdi.accountCircle),
            onPressed: () {
              _flipController.flip!();
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder<User?>(
        future: () async {
          final user = await di.get<AuthService>().getUser();
          if(carreraActiva == null) {
            await di.get<CarrerasService>().getCarreras(forceRefresh: true);
          }

          return user;
        }(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(
              title: "Ocurrió un error al generar tu crendencial",
              error: snapshot.error,
            );
          }

          final user = snapshot.data;

          if (!snapshot.hasData || user == null) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Center(
                      child: LoadingIndicator(),
                    ),
                  ),
                ],
              ),
            );
          }

          if (user.rut != null && carreraActiva!.nombre != null && carreraActiva.nombre!.isNotEmpty) {
            return Center(
              child: SafeArea(
                child: CredencialCard(
                  user: user,
                  carrera: carreraActiva,
                  controller: _flipController,
                  onFlip: (direction) => _onFlip(),
                ),
              ),
            );
          }

          return Container(
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

  void _onFlip() {
    AnalyticsService.logEvent("credencial_flip");
    setState(() {});
  }
}
