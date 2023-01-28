import 'package:flutter/material.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/screens/horario/widgets/horario_blocks_content.dart';
import 'package:mi_utem/screens/horario/widgets/horario_corner.dart';
import 'package:mi_utem/screens/horario/widgets/horario_days_header.dart';
import 'package:mi_utem/screens/horario/widgets/horario_indicator.dart';
import 'package:mi_utem/screens/horario/widgets/horario_periods_header.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class HorarioMainScroller extends StatefulWidget {
  static const double blockWidth = 320.0;
  static const double blockHeight = 200.0;
  static const double blockInternalMargin = 10.0;
  static const double dayHeight = 50.0;
  static const double dayWidth = blockWidth;
  static const double periodHeight = blockHeight;
  static const double periodWidth = 65.0;
  static const double borderWidth = 2.0;

  static const double defaultMaxScale = 1.0;
  static const double defaultMinScale = 0.1;

  final Horario horario;

  const HorarioMainScroller({
    Key? key,
    required this.horario,
  }) : super(key: key);

  @override
  State<HorarioMainScroller> createState() => _HorarioMainScrollerState();

  int get daysCount => horario.horarioEnlazado[0].length;
  int get periodsCount => horario.horarioEnlazado.length ~/ 2;

  double get daysWidth => dayWidth * daysCount;
  double get periodsHeight => periodHeight * periodsCount;

  double get totalWidth => daysWidth + periodWidth;
  double get totalHeight => periodsHeight + dayHeight;

  Widget get _horarioBlocksContent => HorarioBlocksContent(
        horario: horario,
        blockHeight: blockHeight,
        blockWidth: blockWidth,
        blockInternalMargin: blockInternalMargin,
      );

  Widget get _horarioDaysHeader => HorarioDaysHeader(
        horario: horario,
        height: dayHeight,
        dayWidth: dayWidth,
      );

  Widget get _horarioPeriodsHeader => HorarioPeriodsHeader(
        horario: horario,
        width: periodWidth,
        periodHeight: periodHeight,
      );

  Widget get _horarioCorner => HorarioCorner(
        height: dayHeight,
        width: periodWidth,
      );

  Widget get basicHorario => Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                _horarioCorner,
                _horarioDaysHeader,
              ],
            ),
            Row(
              children: [
                _horarioPeriodsHeader,
                _horarioBlocksContent,
              ],
            )
          ],
        ),
      );
}

class _HorarioMainScrollerState extends State<HorarioMainScroller> {
  double _zoom = 0.5;

  final _blockContentController = TransformationController();
  final _daysHeaderController = TransformationController();
  final _periodHeaderController = TransformationController();
  final _cornerController = TransformationController();

  @override
  void initState() {
    _initController(_blockContentController);
    _initController(_daysHeaderController);
    _initController(_periodHeaderController);
    _initController(_cornerController);

    _blockContentController.addListener(() {
      final xPosition = _blockContentController.value.getTranslation().x;
      final yPosition = _blockContentController.value.getTranslation().y;
      final zoom = _blockContentController.value.getMaxScaleOnAxis();

      _daysHeaderController.value.setTranslationRaw(xPosition, 0, 0);
      _periodHeaderController.value.setTranslationRaw(0, yPosition, 0);

      _daysHeaderController.value.setDiagonal(
        vector.Vector4(zoom, zoom, zoom, 1),
      );
      _periodHeaderController.value.setDiagonal(
        vector.Vector4(zoom, zoom, zoom, 1),
      );
      _cornerController.value.setDiagonal(
        vector.Vector4(zoom, zoom, zoom, 1),
      );

      setState(() {
        _zoom = zoom;
      });
    });

    _daysHeaderController.addListener(() {
      final xPosition = _daysHeaderController.value.getTranslation().x;
      final zoom = _daysHeaderController.value.getMaxScaleOnAxis();

      final contentYPosition = _blockContentController.value.getTranslation().y;

      _blockContentController.value
          .setTranslationRaw(xPosition, contentYPosition, 0);

      _blockContentController.value.setDiagonal(
        vector.Vector4(zoom, zoom, zoom, 1),
      );
      _periodHeaderController.value.setDiagonal(
        vector.Vector4(zoom, zoom, zoom, 1),
      );
      _cornerController.value.setDiagonal(
        vector.Vector4(zoom, zoom, zoom, 1),
      );

      setState(() {
        _zoom = zoom;
      });
    });

    _periodHeaderController.addListener(() {
      final yPosition = _periodHeaderController.value.getTranslation().y;
      final zoom = _periodHeaderController.value.getMaxScaleOnAxis();

      final contentXPosition = _blockContentController.value.getTranslation().x;

      _periodHeaderController.value.setTranslationRaw(0, yPosition, 0);

      _blockContentController.value
          .setTranslationRaw(contentXPosition, yPosition, 0);

      _blockContentController.value.setDiagonal(
        vector.Vector4(zoom, zoom, zoom, 1),
      );
      _daysHeaderController.value.setDiagonal(
        vector.Vector4(zoom, zoom, zoom, 1),
      );
      _cornerController.value.setDiagonal(
        vector.Vector4(zoom, zoom, zoom, 1),
      );

      setState(() {
        _zoom = zoom;
      });
    });
    super.initState();
  }

  void _initController(TransformationController controller) {
    controller.value = Matrix4.identity();
    controller.value.setDiagonal(vector.Vector4(_zoom, _zoom, _zoom, 1));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            height: widget.periodsHeight,
            width: widget.daysWidth,
            margin: EdgeInsets.only(
              top: HorarioMainScroller.dayHeight * _zoom,
              left: HorarioMainScroller.periodWidth * _zoom,
            ),
            child: InteractiveViewer(
              transformationController: _blockContentController,
              maxScale: HorarioMainScroller.defaultMaxScale,
              minScale: HorarioMainScroller.defaultMinScale,
              alignPanAxis: false,
              clipBehavior: Clip.none,
              constrained: false,
              onInteractionUpdate: (interaction) {},
              child: SafeArea(
                child: widget._horarioBlocksContent,
              ),
            ),
          ),
          Container(
            width: widget.daysWidth,
            height: HorarioMainScroller.dayHeight,
            margin: EdgeInsets.only(
              left: HorarioMainScroller.periodWidth * _zoom,
            ),
            child: InteractiveViewer(
              transformationController: _daysHeaderController,
              maxScale: HorarioMainScroller.defaultMaxScale,
              minScale: HorarioMainScroller.defaultMinScale,
              alignPanAxis: false,
              scaleEnabled: false,
              clipBehavior: Clip.none,
              constrained: false,
              onInteractionUpdate: (interaction) {},
              child: SafeArea(
                child: widget._horarioDaysHeader,
              ),
            ),
          ),
          Container(
            width: HorarioMainScroller.periodWidth,
            height: HorarioMainScroller.dayHeight,
            child: InteractiveViewer(
              transformationController: _cornerController,
              maxScale: HorarioMainScroller.defaultMaxScale,
              minScale: HorarioMainScroller.defaultMinScale,
              alignPanAxis: false,
              scaleEnabled: false,
              panEnabled: false,
              clipBehavior: Clip.none,
              constrained: false,
              onInteractionUpdate: (interaction) {},
              child: SafeArea(
                child: widget._horarioCorner,
              ),
            ),
          ),
          Container(
            width: HorarioMainScroller.periodWidth,
            height: widget.periodsHeight,
            margin: EdgeInsets.only(
              top: HorarioMainScroller.dayHeight * _zoom,
            ),
            child: InteractiveViewer(
              transformationController: _periodHeaderController,
              maxScale: HorarioMainScroller.defaultMaxScale,
              minScale: HorarioMainScroller.defaultMinScale,
              alignPanAxis: false,
              scaleEnabled: false,
              clipBehavior: Clip.none,
              constrained: false,
              onInteractionUpdate: (interaction) {},
              child: SafeArea(
                child: Stack(
                  children: [
                    widget._horarioPeriodsHeader,
                    HorarioIndicator(
                      maxWidth: widget.daysWidth,
                      initialMargin: EdgeInsets.only(
                        top: HorarioMainScroller.dayHeight,
                        left: HorarioMainScroller.periodWidth,
                      ),
                      heightByMinute: HorarioMainScroller.blockHeight / 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
