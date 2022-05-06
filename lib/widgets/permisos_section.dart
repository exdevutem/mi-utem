import 'package:flutter/material.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/services/permisos_covid_service.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/permisos_card.dart';

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
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 30.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              children: [
                Text(
                  "PERMISOS ACTIVOS",
                  style: TextStyle(
                    color: Color(0xFF363636),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          SizedBox(
            height: 175,
            child: FutureBuilder(
              future: _permisosFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return Center(child: LoadingIndicator(),);
                }

                if (snapshot.data.length == 0) {
                  return Text('No hay permisos COVID');
                }

                return ListView.builder(
                  itemCount: snapshot.data.length,
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => PermisosCard(
                    permiso: snapshot.data[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

