import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BloquePeriodoCard extends StatelessWidget{

  final String? inicio;
  final String? intermedio;
  final String? fin;
  final double ancho;
  final double alto;

  BloquePeriodoCard({
    Key? key,
    required this.inicio,
    required this.intermedio,
    required this.fin,
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
            Text(inicio!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )),
            Text(intermedio!,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                letterSpacing: 0.5,
                wordSpacing: 1, 
                color: Colors.black54,
                fontSize: 14
              )),
            Text(fin!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 18
              ))
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
        color: Colors.blueGrey[200],
      ),
      height: alto,
      width: ancho,
    );
  }
}