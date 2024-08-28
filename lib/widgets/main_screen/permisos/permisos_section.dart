import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/core/models/exceptions/custom_exception.dart';
import 'package:mi_utem/core/models/permiso_ingreso.dart';
import 'package:mi_utem/core/services/permisos_service.dart';
import 'package:mi_utem/widgets/loading/loading_indicator.dart';
import 'package:mi_utem/widgets/main_screen/permisos/permiso_card.dart';

class PermisosCovidSection extends StatelessWidget {

  const PermisosCovidSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Text("Permisos activos".toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
      SizedBox(height: 10),
      SizedBox(
        height: 155,
        child: FutureBuilder<List<PermisoIngreso>>(
          future: Get.find<PermisosService>().getPermisos(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return LoadingIndicator.centeredDefault();
            }

            if(snapshot.hasError) {
              final error = snapshot.error is CustomException ? (snapshot.error as CustomException).message : "Ocurrió un error al cargar los permisos";
              return Text(error);
            }

            if(snapshot.data == null || snapshot.data?.isNotEmpty != true) {
              return Text('No hay permisos de ingresos');
            }

            return ListView.separated(
              itemCount: snapshot.data!.length,
              padding: EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => Container(width: 10),
              itemBuilder: (context, index) => PermisoCard(
                permiso: snapshot.data![index],
              ),
            );
          },
        ),
      ),
    ],
  );
}
