import 'package:flutter/material.dart';

class AvanceRamoCard extends StatelessWidget {
  final String nombre;
  final String sub;
  final String nivel;
  final String nota;

  AvanceRamoCard(
      {Key? key,
      required this.nombre,
      required this.sub,
      required this.nivel,
      required this.nota})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(nivel),
        title: Text(nombre),
        subtitle: Text(sub),
        trailing: Text(nota),
      ),
    );
  }
}
