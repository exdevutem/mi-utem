import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressButton extends StatefulWidget {
  final Function callback;

  ProgressButton(this.callback);

  @override
  State<StatefulWidget> createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton>
    with TickerProviderStateMixin {
  int _state = 0;
  double _width = double.infinity;
  late Animation _animation;
  GlobalKey _globalKey = GlobalKey();
  late AnimationController _controller;

  @override
  void deactivate() {
    reset();
    super.deactivate();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          key: _globalKey,
          height: 48.0,
          width: _width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: _state == 2 ? Colors.green : Get.theme.primaryColor,
              padding: EdgeInsets.zero,
            ),
            child: buildButtonChild(),
            onPressed: () {},
            onFocusChange: (isPressed) {
              setState(() {
                if (_state == 0) {
                  animateButton();
                }
              });
            },
          ),
        ));
  }

  void animateButton() {
    double initialWidth = _globalKey.currentContext!.size!.width;

    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 48.0) * _animation.value);
        });
      });
    _controller.forward();

    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 2;
      });
    });

    Timer(Duration(milliseconds: 3600), () {
      widget.callback();
    });
  }

  Widget buildButtonChild() {
    if (_state == 0) {
      return Text(
        'INICIAR',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      );
    } else if (_state == 1) {
      return SizedBox(
        height: 20.0,
        width: 20.0,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void reset() {
    _width = double.infinity;
    _state = 0;
  }
}
