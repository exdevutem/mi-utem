import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/screens/asignatura_screen.dart';

class BloqueRamoCard extends StatelessWidget {
  final Color colorTexto = Colors.white;
  final double width;
  final double height;
  BloqueHorario bloque;

  BloqueRamoCard(
      {Key? key,
      required this.bloque,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height + 20,
      width: width,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        border: Border(
          right: BorderSide(
            color: Color(0xFFBDBDBD),
            style: BorderStyle.solid,
            width: 1,
          ),
          bottom: BorderSide(
            color: Color(0xFFBDBDBD),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            if (bloque.asignatura != null) {
              Get.to(
                AsignaturaScreen(asignatura: bloque.asignatura!),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: bloque.asignatura != null
                  ? bloque.asignatura!.colorAsignatura
                  : Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: bloque.asignatura != null
                ? Column(
                    children: <Widget>[
                      Text(
                        "${bloque.asignatura!.codigo}/${bloque.asignatura!.seccion}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorTexto,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        bloque.asignatura!.nombre!.toUpperCase(),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          wordSpacing: 1,
                          color: colorTexto,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        bloque.sala!,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          color: colorTexto,
                          fontSize: 18,
                        ),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  )
                : DottedBorder(
                    strokeWidth: 2,
                    color: Color(0xFF7F7F7F),
                    borderType: BorderType.RRect,
                    radius: Radius.circular(15),
                    child: Container(),
                  ),

            // child: bloque.asignatura != null
            //     ? Card(
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(15.0),
            //             side: BorderSide(
            //               color: Colors.transparent,
            //               width: 0,
            //               style: BorderStyle.none,
            //             )),
            //         margin: EdgeInsets.all(5.0),
            //         child: Material(
            //           color: Colors.transparent,
            //           child: InkWell(
            //             onTap: () {
            //               if (bloque.asignatura != null) {
            //                 Get.to(
            //                   AsignaturaScreen(asignatura: bloque.asignatura!),
            //                 );
            //               }
            //             },
            //             borderRadius: BorderRadius.all(Radius.circular(15)),
            //             child: Padding(
            //               padding: EdgeInsets.all(15),
            //               child: Column(
            //                 children: <Widget>[
            //                   Text(
            //                       "${bloque.asignatura!.codigo}/${bloque.asignatura!.seccion}",
            //                       textAlign: TextAlign.center,
            //                       style:
            //                           TextStyle(color: colorTexto, fontSize: 12)),
            //                   Text(bloque.asignatura!.nombre!.toUpperCase(),
            //                       maxLines: 3,
            //                       textAlign: TextAlign.center,
            //                       style: TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           letterSpacing: 0.5,
            //                           wordSpacing: 1,
            //                           color: colorTexto,
            //                           fontSize: 14)),
            //                   Text(bloque.sala!,
            //                       textAlign: TextAlign.center,
            //                       maxLines: 2,
            //                       style:
            //                           TextStyle(color: colorTexto, fontSize: 12))
            //                 ],
            //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //               ),
            //             ),
            //           ),
            //         ),
            //         color: bloque.asignatura!.colorAsignatura,
            //       )
            //     : Container(
            // margin: EdgeInsets.all(5.0),
            // child: DottedBorder(
            //     color: Colors.grey[400]!,
            //     strokeWidth: 2,
            //     borderType: BorderType.RRect,
            //     radius: Radius.circular(15.0),
            //     child: ClipRRect(
            //         borderRadius: BorderRadius.all(Radius.circular(13.0)),
            //         child: Container(color: Colors.grey[200]))),
            // ),
          ),
        ),
      ),
    );
  }
}
