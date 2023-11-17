import 'package:flutter/material.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/widgets/asignatura/lista/asignatura_list_tile.dart';

class ListaAsignaturas extends StatelessWidget {
  final List<Asignatura> asignaturas;

  const ListaAsignaturas({
    Key? key,
    required this.asignaturas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.builder(
    physics: AlwaysScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int i) => AsignaturaListTile(asignatura: asignaturas[i]),
    itemCount: asignaturas.length,
  );
}
