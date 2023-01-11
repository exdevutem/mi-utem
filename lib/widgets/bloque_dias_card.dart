import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BloqueDiasCard extends StatelessWidget {
  final String day;
  final double width;
  final double height;
  final bool active;

  BloqueDiasCard({
    Key? key,
    required this.day,
    required this.width,
    required this.height,
    required this.active,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        border: Border(
          right: BorderSide(
            color: Color(0xFFBDBDBD),
            style: BorderStyle.solid,
            width: 1,
          ),
          bottom: BorderSide(
            color: Color(0xFFBDBDBD),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
      ),
      height: height,
      width: width,
      child: Column(
        children: <Widget>[
          Text(
            day.trim(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF363636),
              fontSize: 24,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
