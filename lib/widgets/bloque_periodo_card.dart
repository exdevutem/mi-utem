import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BloquePeriodoCard extends StatelessWidget {
  final String? inicio;
  final String? intermedio;
  final String? fin;
  final double height;
  final double width;
  final bool active;

  BloquePeriodoCard({
    Key? key,
    required this.inicio,
    required this.intermedio,
    required this.fin,
    required this.height,
    required this.width,
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            inicio!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 18,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            intermedio!,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 0.5,
              wordSpacing: 1,
              color: Colors.black54,
              fontSize: 14,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            fin!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 18,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}
