import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/controllers/user_controller.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/widgets/credencial_card.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/flip_widget.dart';

class CredencialScreen extends StatefulWidget {
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

  UserController get controller => UserController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: Text("Credencial universitaria"),
          actions: [
            IconButton(
              icon: Icon(_flipController.actualFace == FlipController.front
                  ? Icons.info
                  : Mdi.accountCircle),
              onPressed: () {
                _flipController.flip!();
              },
            ),
          ],
        ),
        backgroundColor: Colors.grey[200],
        body: Obx(() {
          final user = controller.user.value;
          final selectedCarrera = controller.selectedCarrera.value;

          if (user == null || selectedCarrera == null) {
            return CustomErrorWidget(
              title: "Ocurrió un error al generar tu crendencial",
            );
          }

          return Center(
            child: SafeArea(
              child: CredencialCard(
                usuario: user,
                carrera: selectedCarrera,
                controller: _flipController,
                onFlip: (direction) => _onFlip(),
              ),
            ),
          );
        }));
  }

  void _onFlip() {
    AnalyticsService.logEvent("credencial_flip");
    setState(() {});
  }
}
