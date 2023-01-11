import 'dart:math';

import 'package:flutter/material.dart';

import 'package:simple_gesture_detector/simple_gesture_detector.dart';

class FlipController {
  static const front = "Front";
  static const rear = "Rear";

  Function([SwipeDirection])? flip;
  String actualFace = front;

  void dispose() {
    flip = null;
    actualFace = front;
  }
}

class FlipWidget extends StatefulWidget {
  final Widget front, back;
  final FlipController? controller;
  final Function(SwipeDirection?)? onFlip;

  FlipWidget({Key? key, required this.front, required this.back, this.controller, this.onFlip}) : super(key: key);

  @override
  _FlipWidgetState createState() => _FlipWidgetState();
}

class _FlipWidgetState extends State<FlipWidget> with SingleTickerProviderStateMixin {
  late Animation _animation;
  late AnimationController _animationController;
  SwipeDirection? _direction;
  bool _showFront = true;

  @override
  void initState() {
    _animationController = AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    FlipController? _flipController = widget.controller;
    if (_flipController != null) {
      _flipController.flip = _flip;
      _flipController.actualFace = _showFront ? FlipController.front : FlipController.rear;
    }
    
    super.initState();
  }

  _flip([SwipeDirection direction = SwipeDirection.right]) {
    if (widget.controller != null) {
      widget.controller!.actualFace = !_showFront ? FlipController.front : FlipController.rear;
    }
    setState(() {
      _direction = direction;
      _showFront = !_showFront;
    });
    if (_animation.isDismissed) {
      _animationController.forward();
    } else if (_animation.isCompleted) {
      _animationController.reverse();
    }
    if (widget.onFlip != null) {
      widget.onFlip!(direction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        bool isFront = _animationController.value < .5;
        return SimpleGestureDetector(
          onHorizontalSwipe: _flip,
          swipeConfig: SimpleSwipeConfig(
            verticalThreshold: 40.0,
            horizontalThreshold: 40.0,
            swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
          ),
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(pi * _animation.value * (_direction == SwipeDirection.left ? (_showFront ? -1 : 1) : (_showFront ? 1 : -1)) + (isFront ? 0 : pi)),
            alignment: FractionalOffset.center,
            
            child: isFront ? widget.front : widget.back,
          ),
        );
    
          
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
