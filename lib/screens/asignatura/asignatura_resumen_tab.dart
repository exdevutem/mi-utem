import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/field_list_tile.dart';

class AsignaturaResumenTab extends StatelessWidget {
  final Asignatura? asignatura;

  AsignaturaResumenTab({
    Key? key,
    this.asignatura,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return asignatura == null
        ? CustomErrorWidget(
            title: "Ocurrió un error al obtener el resumen de la asignatura",
            error: '',
          )
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Container(
                    child: ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        Container(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          width: double.infinity,
                          child: Text(
                            "Resumen".toUpperCase(),
                            style: Get.textTheme.bodyLarge,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        FieldListTile(
                          title: "Nombre",
                          value: asignatura?.nombre,
                        ),
                        Divider(height: 5, indent: 20, endIndent: 20),
                        FieldListTile(
                          title: "Código",
                          value: asignatura?.codigo,
                        ),
                        if (asignatura?.seccion != null &&
                            asignatura!.seccion!.isNotEmpty) ...[
                          Divider(height: 5, indent: 20, endIndent: 20),
                          FieldListTile(
                            title: "Sección",
                            value: asignatura!.seccion.toString(),
                          ),
                        ],
                        Divider(height: 5, indent: 20, endIndent: 20),
                        FieldListTile(
                          title: "Docente",
                          value: asignatura?.docente ?? "Sin docente",
                          // trailing: _asignatura.docente != null
                          //     ? Badge(
                          //         shape: BadgeShape.square,
                          //         borderRadius: BorderRadius.circular(10),
                          //         padding: EdgeInsets.symmetric(
                          //             horizontal: 6, vertical: 3),
                          //         elevation: 0,
                          //         badgeContent: Text(
                          //           'Nuevo',
                          //           style: TextStyle(
                          //             color: Colors.white,
                          //             fontSize: 10,
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                          //       )
                          //     : null,
                          // onTap: _asignatura.docente != null
                          //     ? () async {
                          //         await Get.to(() =>
                          //           UsuarioScreen(
                          //             tipo: 2,
                          //             query: {
                          //               "nombre": _asignatura.docente
                          //             },
                          //             asignatura: widget.asignatura,
                          //           ),
                          //         );
                          //       }
                          //     : null,
                        ),
                        Divider(height: 5, indent: 20, endIndent: 20),
                        if (asignatura?.tipoAsignatura != null) ...[
                          FieldListTile(
                            title: "Tipo de asignatura",
                            value: asignatura!.tipoAsignatura!,
                          ),
                          Divider(height: 5, indent: 20, endIndent: 20),
                        ],
                        FieldListTile(
                          title: "Tipo de hora",
                          value: asignatura?.tipoHora,
                        ),
                        Divider(height: 5, indent: 20, endIndent: 20),
                        if (asignatura?.horario != null) ...[
                          FieldListTile(
                            title: "Horario",
                            value: asignatura!.horario!,
                          ),
                          Divider(height: 5, indent: 20, endIndent: 20),
                        ],
                        FieldListTile(
                          title: "Intentos",
                          value: asignatura?.intentos.toString(),
                        ),
                        Divider(height: 5, indent: 20, endIndent: 20),
                        FieldListTile(
                          title: "Sala",
                          value: asignatura?.sala,
                        ),
                      ],
                    ),
                  ),
                ),
                // Card(
                //   child: Container(
                //     padding: EdgeInsets.all(20),
                //     child: Column(
                //       children: [
                //         Container(
                //           width: double.infinity,
                //           child: Text(
                //             "Asistencia".toUpperCase(),
                //             style: Get.textTheme.headline4,
                //             textAlign: TextAlign.left,
                //           ),
                //         ),
                //         AsistenciaChart(asistencia: _asignatura.asistencia),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          );
  }
}
