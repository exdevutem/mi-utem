import 'package:flutter/material.dart';
import 'package:mi_utem/core/models/asignaturas/asignatura.dart';
import 'package:mi_utem/core/models/horario.dart';
import 'package:mi_utem/widgets/modals/persona_modal.dart';

class AsignaturaVistaPreviaModal extends StatelessWidget {
  final Asignatura asignatura;
  final BloqueHorario bloque;

  const AsignaturaVistaPreviaModal({
    super.key,
    required this.asignatura,
    required this.bloque,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Container(
      alignment: Alignment.topCenter,
      child: Card(
        margin: const EdgeInsets.all(20),
        child: ListView(
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            GestureDetector(
              child: ListTile(
                title: Text(asignatura.nombre),
                subtitle: Text(asignatura.docente.nombreCompleto), // Se filtran enteros, al parecer hay algunos textos que incluyen un identificador.
              ),
              onTap: () async => showModalBottomSheet(context: context, builder: (ctx) => PersonaModal(persona: asignatura.docente)),
            ),
            if (asignatura.seccion.isNotEmpty) ...[
              Divider(height: 5, indent: 20, endIndent: 20),
              ListTile(
                title: Text("Sección"),
                subtitle: Text(asignatura.seccion.toString()),
              ),
            ],
            Divider(height: 5, indent: 20, endIndent: 20),
            ListTile(
              title: Text("Código Asignatura"),
              subtitle: Text(asignatura.codigo.toString()),
            ),
            Divider(height: 5, indent: 20, endIndent: 20),
            ListTile(
              title: Text("Sala"),
              subtitle: Text(bloque.sala ?? "Sin sala"),
            ),
          ],
        ),
      ),
    ),
  );
}
