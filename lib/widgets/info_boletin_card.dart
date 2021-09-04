import 'package:flutter/material.dart';

class InfoBoletinCard extends StatelessWidget{
  final String? inicio;
  final String? termino;
  final String? plan;
  final String? estado;
  final String? ingreso;

  InfoBoletinCard({
    Key? key,
    this.inicio,
    this.termino,
    this.plan,
    this.estado,
    this.ingreso
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
            leading: Icon(Icons.book),
            title: Text('Plan: $plan'),
            ),
            ListTile(
            leading: Icon(Icons.person),
            title: Text('Estado: $estado'),
            ),
            ListTile(
            leading: Icon(Icons.create),
            title: Text('Vía de ingreso: $ingreso'),
            ),
            ListTile(
            leading: Icon(Icons.date_range),
            title: Text('Semestre de inicio: $inicio'),
            ),
            ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Semestre de término: $termino'),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
        color: Colors.white,
      ),
      alignment: Alignment.topCenter,
    );
  }
}