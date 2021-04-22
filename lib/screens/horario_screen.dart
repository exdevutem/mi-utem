import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:diagonal_scrollview/diagonal_scrollview.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbar/flutter_statusbar.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/config_service.dart';
import 'package:mi_utem/services/horarios_service.dart';
import 'package:mi_utem/services/review_service.dart';
import 'package:mi_utem/widgets/bloque_dias_card.dart';
import 'package:mi_utem/widgets/bloque_periodo_card.dart';
import 'package:mi_utem/widgets/bloque_ramo_card.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';
import 'package:vector_math/vector_math_64.dart';

class HorarioScreen extends StatefulWidget {
  HorarioScreen({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HorarioScreenState();
}

class _HorarioScreenState extends State<HorarioScreen> {
  final double _childWidth = 150.0;
  final double _childHeight = 150.0;
  final double _diasHeight = 50.0;
  final double _periodosWidth = 150.0;

  final CustomAppBar appBar = CustomAppBar(
    title: Text("Horario"),
  );
  Future<Horario> _horarioFuture;
  Horario _horario;
  TransformationController _controller;

  RemoteConfig _remoteConfig;

  @override
  void initState() {
    super.initState();
    _remoteConfig = ConfigService.config;

    double zoom = _remoteConfig.getDouble(ConfigService.HORARIO_ZOOM);
    _controller = TransformationController();
    _controller.value = Matrix4.identity();
    _controller.value.setDiagonal(Vector4(zoom, zoom, zoom, 1));

    ReviewService.addScreen("HorarioScreen");
    FirebaseAnalytics().setCurrentScreen(screenName: 'HorarioScreen');
    _horarioFuture = _getHorario();
    _getHorarioActualizado();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  Future<Horario> _getHorario() async {
    Horario horario = await HorarioService.getHorario();
    setState(() {
      _horario = horario;
    });
    return horario;
  }

  Future<Horario> _getHorarioActualizado() async {
    Horario horarioActualizado = await HorarioService.getHorario(true);
    setState(() {
      _horario = horarioActualizado;
    });
    return horarioActualizado;
  }

  List<TableRow> _getChildren(Horario horario) {
    List<TableRow> filas = [];

    /* for (List<BloqueHorario> dia in horario.horarioEnlazado) {
      BloqueHorario bloqueAuxiliar = bloque;
      int periodo = int.parse(bloque.numero);
      int dia = int.parse(bloque.dia);
      if ((periodo % 2) == 0) {
        matriz[(periodo ~/ 2) - 1][dia - 1] = bloqueAuxiliar;
      }
    } */

    // Container vacio para la esquina superior izquierda
    List<Widget> filaWidgets = [Container()];

    // Primera fila de los días
    for (String dia in horario.dias) {
      filaWidgets.add(BloqueDiasCard(
        dia: dia,
        alto: _diasHeight,
        ancho: _childWidth,
      ));
    }
    filas.add(TableRow(children: filaWidgets));

    // Se llena el resto
    for (num i = 0; i < horario.horarioEnlazado.length; i++) {
      filaWidgets = [];
      if ((i % 2) == 0) {
        List<BloqueHorario> periodo = horario.horarioEnlazado[i];
        for (num j = 0; j < periodo.length; j++) {
          BloqueHorario bloque = horario.horarioEnlazado[i][j];
          if (j == 0) {
            filaWidgets.add(BloquePeriodoCard(
              inicio: horario.horasInicio[i ~/ 2],
              intermedio: horario.horasIntermedio[i ~/ 2],
              fin: horario.horasTermino[i ~/ 2],
              alto: _childHeight,
              ancho: _periodosWidth,
            ));
          }

          print("bloque ${bloque.codigo} ${bloque.asignatura}");

          filaWidgets.add(BloqueRamoCard(
            alto: _childHeight,
            ancho: _childWidth,
            bloque: bloque,
          ));
        }
        filas.add(TableRow(children: filaWidgets));
      }
    }

    return filas;
  }

  Future<void> _onRefresh() async {
    await _getHorario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: FutureBuilder(
        future: _horarioFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            DioError dioError;

            if (snapshot.error is DioError) {
              dioError = snapshot.error;
            }

            if (dioError != null && dioError.response.statusCode == 404) {
              return CustomErrorWidget(
                  emoji: "🤔",
                  texto: "Parece que no se encontró el horario",
                  error: snapshot.error);
            }
            return CustomErrorWidget(
                texto: "Ocurrió un error al obtener el horario",
                error: snapshot.error);
          } else {
            if (snapshot.hasData) {
              Horario horario = _horario;
              if (snapshot.hasData) {
                return PullToRefresh(
                  onRefresh: () async {
                    await _onRefresh();
                  },
                  
                  child: InteractiveViewer(
                    transformationController: _controller,
                    maxScale: 1,
                    minScale: 0.1,
                    alignPanAxis: false,
                    clipBehavior: Clip.none,
                    constrained: false,
                    onInteractionUpdate: (interaction) {
                     /*  print("onInteractionUpdate focalPoint ${interaction.focalPoint.toString()}");
                      print("onInteractionUpdate horizontalScale ${interaction.horizontalScale.toString()}");
                      print("onInteractionUpdate localFocalPoint ${interaction.localFocalPoint.toString()}");
                      print("onInteractionUpdate verticalScale ${interaction.verticalScale.toString()}");
                      print("onInteractionUpdate pointerCount ${interaction.pointerCount.toString()}");
                      print("onInteractionUpdate rotation ${interaction.rotation.toString()}");
                      print("onInteractionUpdate scale ${interaction.scale.toString()}");
                      print("onInteractionUpdate matrix");
                      print("onInteractionUpdate matrix[0] ${_controller.value.row0}");
                      print("onInteractionUpdate matrix[1] ${_controller.value.row1}");
                      print("onInteractionUpdate matrix[2] ${_controller.value.row2}");
                      print("onInteractionUpdate matrix[3] ${_controller.value.row3}");
                      
                      [[escala, 0, 0, -posY],
                       [0, escala, 0, -posX],
                       [0, 0, escala, 0],
                       [0. 0, 0, 1]]
                      
                      */
                      if (interaction.scale >= 0.8) {
                        print("HEY");
                      }
                    },
                    child: SafeArea(
                      child: Table(
                        defaultColumnWidth: FixedColumnWidth(_childWidth),
                        children: _getChildren(horario),
                      ),
                    ),
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
}
