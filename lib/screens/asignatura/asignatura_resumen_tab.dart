import 'package:flutter/material.dart';
import 'package:mi_utem/models/asignaturas/asignatura.dart';
import 'package:mi_utem/utils/string_utils.dart';
import 'package:mi_utem/widgets/field_list_tile.dart';

class AsignaturaResumenTab extends StatelessWidget {
  final Asignatura asignatura;

  AsignaturaResumenTab({
    Key? key,
    required this.asignatura,
  }) : super(key: key);

  List<Map<String, String>>? get datosHorario => asignatura.horario?.split("||").map((e) => e.trim()).map((it) => {
    'dia': capitalize(it.split("|")[0]).trim(),
    'horas': it.split("|")[1].split("/").map((it) => it.trim()).map((it) => "- $it").join("\n"),
  }).toList();

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Container(
            child: ListView(
              padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  child: Text("Asignatura".toUpperCase(),
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.left,
                  ),
                ),
                GestureDetector(
                    child: FieldListTile(
                      title: "Docente",
                      value: asignatura.docente?.split(" ").where((element) => int.tryParse(element) == null).join(" ") ?? "Sin docente", // Se filtran enteros, al parecer hay algunos textos que incluyen un identificador.
                    ),
                    onTap: () async {
                      // TODO: Mostrar perfil del docente.
                    },
                  ),
                if (asignatura.seccion?.isNotEmpty == true) ...[
                    Divider(height: 5, indent: 20, endIndent: 20),
                    FieldListTile(
                      title: "Sección",
                      value: asignatura.seccion.toString(),
                    ),
                  ],
                Divider(height: 5, indent: 20, endIndent: 20),
                FieldListTile(
                    title: "Código Asignatura",
                    value: asignatura.codigo,
                  ),
                if (asignatura.tipoAsignatura != null) ...[
                    Divider(height: 5, indent: 20, endIndent: 20),
                    FieldListTile(
                      title: "Tipo de Asignatura",
                      value: asignatura.tipoAsignatura,
                    ),
                    Divider(height: 5, indent: 20, endIndent: 20),
                  ],
                Divider(height: 5, indent: 20, endIndent: 20),
                FieldListTile(
                    title: "Intentos",
                    value: "${asignatura.intentos}",
                  ),

                Divider(height: 5),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  margin: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  child: Text("Sala".toUpperCase(),
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.left,
                  ),
                ),
                FieldListTile(
                  title: "Tipo de hora",
                  value: asignatura.tipoHora,
                ),
                Divider(height: 5, indent: 20, endIndent: 20),
                FieldListTile(
                  title: "Sala",
                  value: asignatura.sala,
                ),

                Divider(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  margin: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  child: Text("Horario".toUpperCase(),
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.left,
                  ),
                ),
                ...datosHorario?.map((it) => Column(
                  children: [
                    FieldListTile(
                        title: it['dia'] ?? "",
                        value: it['horas']
                    ),
                    if ("${datosHorario?.last['dia']} ${datosHorario?.last['horas']}" != "${it['dia']} ${it['horas']}") Divider(height: 5, indent: 20, endIndent: 20),
                  ],
                )).toList() ?? [],
              ],
            ),
          ),
        ),
        // Card(
        //     child: Container(
        //       child: ListView(
        //         padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
        //         shrinkWrap: true,
        //         physics: ScrollPhysics(),
        //         children: [
        //           Container(
        //             padding: EdgeInsets.symmetric(horizontal: 15),
        //             width: double.infinity,
        //             child: Text("Sala".toUpperCase(),
        //               style: Get.textTheme.bodyLarge,
        //               textAlign: TextAlign.left,
        //             ),
        //           ),
        //           FieldListTile(
        //             title: "Tipo de hora",
        //             value: asignatura.tipoHora,
        //           ),
        //           Divider(height: 5, indent: 20, endIndent: 20),
        //           FieldListTile(
        //             title: "Sala",
        //             value: asignatura.sala,
        //           ),
        //         ],
        //       ),
        //     )
        // ),
        // Card(
        //   child: Container(
        //     child: ListView(
        //       padding: EdgeInsets.only(top: 20.0, bottom: 5.0),
        //       shrinkWrap: true,
        //       physics: ScrollPhysics(),
        //       children: [
        //         Container(
        //           padding: EdgeInsets.symmetric(horizontal: 15),
        //           width: double.infinity,
        //           child: Text("Horario".toUpperCase(),
        //             style: Get.textTheme.bodyLarge,
        //             textAlign: TextAlign.left,
        //           ),
        //         ),
        //         ...datosHorario?.map((it) => Column(
        //           children: [
        //             FieldListTile(
        //                 title: it['dia'] ?? "",
        //                 value: it['horas']
        //             ),
        //             if ("${datosHorario?.last['dia']} ${datosHorario?.last['horas']}" != "${it['dia']} ${it['horas']}") Divider(height: 5, indent: 20, endIndent: 20),
        //           ],
        //         )).toList() ?? [],
        //       ],
        //     ),
        //   ),
        // ),
      ],
    ),
  );
}
