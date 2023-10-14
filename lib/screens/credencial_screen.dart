import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/controllers/carreras_controller.dart';
import 'package:mi_utem/controllers/user_controller.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/widgets/credencial_card.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/flip_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';

class CredencialScreen extends StatefulWidget {
  CredencialScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CredencialScreenState();
}

class _CredencialScreenState extends State<CredencialScreen> {
  Future? _future;
  Usuario? _usuario;
  FlipController _flipController = FlipController();

  @override
  void initState() {
    ReviewService.addScreen("CredencialScreen");
    _secureScreen();
    _future = _getData();
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

  Future _getData() async {
    try {
      Usuario usuario = UserController.to.getUser();
      setState(() {
        _usuario = usuario;
      });
      return usuario;
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    Carrera? carreraActiva = CarrerasController.to.selectedCarrera.value;

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
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(
                title: "Ocurrió un error al generar tu crendencial",
                error: snapshot.error);
          } else {
            if (snapshot.hasData) {
              if (_usuario!.rut != null &&
                  carreraActiva!.nombre != null &&
                  carreraActiva.nombre!.isNotEmpty) {
                return Center(
                  child: SafeArea(
                    child: CredencialCard(
                      usuario: _usuario,
                      carrera: carreraActiva,
                      controller: _flipController,
                      onFlip: (direction) => _onFlip(),
                    ),
                  ),
                );
              } else {
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "😕",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50,
                        ),
                      ),
                      Container(height: 15),
                      Text(
                        "Ocurrió un error al generar tu credencial",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Container(height: 15),
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
            } else {
              return Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: LoadingIndicator(),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _onFlip() {
    AnalyticsService.logEvent("credencial_flip");
    setState(() {});
  }
}
