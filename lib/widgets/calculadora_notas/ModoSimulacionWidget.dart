import 'package:flutter/material.dart';

class ModoSimulacionWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Container(
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
  );
}
