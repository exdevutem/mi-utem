import 'package:flutter/material.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/screens/asignatura/asignatura_detalle_screen.dart';
import 'package:mi_utem/themes/theme.dart';

class AsignaturaListTile extends StatelessWidget {
  final Asignatura asignatura;

  const AsignaturaListTile({
    super.key,
    required this.asignatura,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Card(
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => AsignaturaDetalleScreen(
          asignatura: asignatura,
        ))),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${asignatura.nombre}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: MainTheme.theme.textTheme.titleMedium,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${asignatura.codigo}"),
                  Text("${asignatura.tipoHora}"),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );

}