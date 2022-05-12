import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/services/permisos_covid_service.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/permiso_card.dart';

class PermisosCovidSection extends StatefulWidget {
  const PermisosCovidSection({Key? key}) : super(key: key);

  @override
  State<PermisosCovidSection> createState() => _PermisosCovidSectionState();
}

class _PermisosCovidSectionState extends State<PermisosCovidSection> {
  late Future<List<PermisoCovid>> _permisosFuture;

  @override
  initState() {
    super.initState();

    _permisosFuture = PermisosCovidService.getPermisos();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                "Permisos activos".toUpperCase(),
                style: Get.textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        Container(height: 10),
        SizedBox(
          height: 155,
          child: FutureBuilder(
            future: _permisosFuture,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return LoadingIndicator(
                  message: "Esto tardará un poco, paciencia...",
                );
              }

              if (snapshot.data.length == 0) {
                return Text('No hay permisos de ingresos');
              }

              return ListView.separated(
                itemCount: snapshot.data.length,
                padding: EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => Container(width: 10),
                itemBuilder: (context, index) => PermisoCard(
                  permiso: snapshot.data[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
