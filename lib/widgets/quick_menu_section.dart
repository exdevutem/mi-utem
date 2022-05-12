import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/screens/asignaturas_screen.dart';

class QuickMenuSection extends StatefulWidget {
  const QuickMenuSection({Key? key}) : super(key: key);

  @override
  State<QuickMenuSection> createState() => _QuickMenuSectionState();
}

class _QuickMenuSectionState extends State<QuickMenuSection> {
  late Future<List<PermisoCovid>> _permisosFuture;

  @override
  initState() {
    super.initState();
  }

  List<Map<String, dynamic>> get _quickMenu => [
        {
          "nombre": "Notas",
          "icono": {
            "codePoint": Icons.book.codePoint,
            "fontFamily": 'MaterialIcons'
          },
        },
        {
          "nombre": "Horario",
          "icono": {
            "codePoint": Mdi.clockTimeEight.codePoint,
            "fontFamily": 'Material Design Icons',
            "fontPackage": "mdi"
          },
        },
        {
          "nombre": "Credencial",
          "icono": {
            "codePoint": Mdi.cardAccountDetails.codePoint,
            "fontFamily": 'Material Design Icons',
            "fontPackage": "mdi"
          },
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Acceso rápido".toUpperCase(),
            style: Get.textTheme.subtitle1!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(height: 10),
        Container(
          height: 130,
          child: ListView.separated(
            itemCount: _quickMenu.length,
            padding: EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => Container(width: 10),
            itemBuilder: (context, index) {
              Map<String, dynamic> e = _quickMenu[index];
              return Container(
                height: 130,
                width: 150,
                child: GradientCard(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  gradient: Gradients.cosmicFusion,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => AsignaturasScreen());
                      },
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconData(
                                e["icono"]["codePoint"],
                                fontFamily: e["icono"]["fontFamily"],
                                fontPackage: e["icono"]["fontPackage"],
                              ),
                              color: Colors.white,
                              size: 30,
                            ),
                            Container(height: 10),
                            Text(
                              e["nombre"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Get.textTheme.headline6!.copyWith(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
