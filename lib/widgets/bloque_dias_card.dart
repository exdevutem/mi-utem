import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BloqueDiasCard extends StatelessWidget{

  final String dia;
  final double ancho;
  final double alto;

  BloqueDiasCard({
    Key? key,
    required this.dia,
    required this.ancho,
    required this.alto
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: <Widget>[
            Text(dia.trim(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        color: Colors.blueGrey[200],
      ),
      height: alto,
      width: ancho,
    );
  }
}