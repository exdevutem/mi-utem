import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/nota_list_item.dart';

class CalculadoraNotasScreen extends StatefulWidget {
  final Asignatura? asignaturaInicial;

  CalculadoraNotasScreen({
    Key? key,
    this.asignaturaInicial,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CalculadoraNotasScreenState();
}

class _CalculadoraNotasScreenState extends State<CalculadoraNotasScreen> {
  MaskedTextController _examenController =
      new MaskedTextController(mask: '0.0');
  MaskedTextController _presentacionController =
      new MaskedTextController(mask: '0.0');

  Asignatura? _asignatura;

  @override
  void initState() {
    super.initState();
    ReviewService.addScreen("CalculadoraNotasScreen");
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'CalculadoraNotasScreen');
    setState(() {
      _examenController.text =
          widget.asignaturaInicial!.notaExamen?.toStringAsFixed(1) ?? "";
      _presentacionController.text = widget
              .asignaturaInicial?.notaPresentacionCalculada
              .toStringAsFixed(1) ??
          "";
      _asignatura = widget.asignaturaInicial;
    });
  }

  void _onCambioNota(String nota, String porcentaje, int i) {
    setState(() {
      _asignatura!.notaExamen = null;
      _asignatura!.notasParciales[i].nota = num.tryParse(nota);
      _examenController.text =
          _asignatura!.notaExamen?.toStringAsFixed(1) ?? "";
      _presentacionController.text =
          _asignatura?.notaPresentacionCalculada.toStringAsFixed(1) ?? "";
      _asignatura = _asignatura;
    });
  }

  @override
  Widget build(BuildContext context) {
    //_procesarNotas(prueba);
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Calculadora de notas"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Card(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: RotationTransition(
                    turns: AlwaysStoppedAnimation(-20 / 360),
                    child: Text(
                      "Modo simulación".toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            _asignatura?.notaFinalCalculada
                                    .toStringAsFixed(1) ??
                                "--",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _asignatura!.estadoCalculado,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(width: 10),
                      Container(
                        height: 80,
                        width: 0.5,
                        color: Colors.grey,
                      ),
                      Container(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Examen",
                                style: TextStyle(fontSize: 16),
                              ),
                              Container(
                                width: 60,
                                margin: EdgeInsets.only(left: 15),
                                child: TextField(
                                  controller: _examenController,
                                  textAlign: TextAlign.center,
                                  onChanged: (String valor) {
                                    num? nota = num.tryParse(valor);
                                    if (valor.isEmpty || nota == null) {
                                      nota = 0;
                                    }
                                    setState(() {
                                      _asignatura!.notaExamen = nota;
                                    });
                                  },
                                  enabled: _asignatura!.puedeDarExamen,
                                  decoration: InputDecoration(
                                    hintText: (_asignatura != null &&
                                            _asignatura!.puedeDarExamen)
                                        ? "≥${_asignatura!.examenMinimoCalculado.toStringAsFixed(1)}"
                                        : "",
                                    filled: !(_asignatura != null &&
                                        _asignatura!.puedeDarExamen),
                                    fillColor: Colors.grey.withOpacity(0.2),
                                    disabledBorder: MainTheme
                                        .theme.inputDecorationTheme.border!
                                        .copyWith(
                                            borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    )),
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                ),
                              ),
                            ],
                          ),
                          Container(height: 10),
                          Row(
                            children: [
                              Text(
                                "Presentacion",
                                style: TextStyle(fontSize: 16),
                              ),
                              Container(
                                width: 60,
                                margin: EdgeInsets.only(left: 15),
                                child: TextField(
                                  controller: _presentacionController,
                                  textAlign: TextAlign.center,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintText: "Nota",
                                    disabledBorder: MainTheme
                                        .theme.inputDecorationTheme.border!
                                        .copyWith(
                                            borderSide: BorderSide(
                                      color: Colors.transparent,
                                    )),
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: RotationTransition(
                    turns: AlwaysStoppedAnimation(-20 / 360),
                    child: Text(
                      "Modo simulación".toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, i) {
                      Evaluacion evaluacion = _asignatura!.notasParciales[i];
                      return NotaListItem(
                        evaluacion: evaluacion,
                        esSimulacion: true,
                        onChanged: (String nota, String porcentaje) {
                          _onCambioNota(nota, porcentaje, i);
                        },
                      );
                    },
                    itemCount: _asignatura!.notasParciales.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
