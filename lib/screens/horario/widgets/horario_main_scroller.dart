import 'package:flutter/material.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/screens/horario/widgets/horario_blocks_content.dart';
import 'package:mi_utem/screens/horario/widgets/horario_corner.dart';
import 'package:mi_utem/screens/horario/widgets/horario_days_header.dart';
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
    super.initState();
  }

  void _initController(TransformationController controller) {
    controller.value = Matrix4.identity();
    controller.value.setDiagonal(vector.Vector4(_zoom, _zoom, _zoom, 1));
  }

  int get _daysCount => widget.horario.horarioEnlazado[0].length;
  int get _periodsCount => widget.horario.horarioEnlazado.length ~/ 2;

  double get _daysWidth => HorarioMainScroller.dayWidth * _daysCount;
  double get _periodsHeight => HorarioMainScroller.periodHeight * _periodsCount;

  double get _totalWith => _daysWidth + HorarioMainScroller.periodWidth;
  double get _totalHeight => _periodsHeight + HorarioMainScroller.dayHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: _periodsHeight,
          width: _daysWidth,
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
              child: HorarioBlocksContent(
                horario: widget.horario,
                blockHeight: HorarioMainScroller.blockHeight,
                blockWidth: HorarioMainScroller.blockWidth,
                blockInternalMargin: HorarioMainScroller.blockInternalMargin,
              ),
            ),
          ),
        ),
        Container(
          width: _daysWidth,
          height: HorarioMainScroller.dayHeight,
          margin: EdgeInsets.only(
            left: HorarioMainScroller.periodWidth * _zoom,
          ),
          child: InteractiveViewer(
            transformationController: _daysHeaderController,
            maxScale: HorarioMainScroller.defaultMaxScale,
            minScale: HorarioMainScroller.defaultMinScale,
            alignPanAxis: false,
            clipBehavior: Clip.none,
            constrained: false,
            onInteractionUpdate: (interaction) {},
            child: SafeArea(
              child: HorarioDaysHeader(
                horario: widget.horario,
                height: HorarioMainScroller.dayHeight,
                dayWidth: HorarioMainScroller.dayWidth,
              ),
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
            clipBehavior: Clip.none,
            constrained: false,
            onInteractionUpdate: (interaction) {},
            child: SafeArea(
              child: HorarioCorner(
                height: HorarioMainScroller.dayHeight,
                width: HorarioMainScroller.periodWidth,
              ),
            ),
          ),
        ),
        Container(
          width: HorarioMainScroller.periodWidth,
          height: _periodsHeight,
          margin: EdgeInsets.only(
            top: HorarioMainScroller.dayHeight * _zoom,
          ),
          child: InteractiveViewer(
            transformationController: _periodHeaderController,
            maxScale: HorarioMainScroller.defaultMaxScale,
            minScale: HorarioMainScroller.defaultMinScale,
            alignPanAxis: false,
            clipBehavior: Clip.none,
            constrained: false,
            onInteractionUpdate: (interaction) {},
            child: SafeArea(
              child: HorarioPeriodsHeader(
                horario: widget.horario,
                periodHeight: HorarioMainScroller.periodHeight,
                width: HorarioMainScroller.periodWidth,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
