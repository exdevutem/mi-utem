import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/asignaturas/asignatura.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/models/user/user.dart';
import 'package:mi_utem/repositories/interfaces/asignaturas_repository.dart';
import 'package:mi_utem/services/analytics_service.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/modals/user_modal.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';


class AsignaturaEstudiantesTab extends StatefulWidget {
  final Asignatura? asignatura;

  const AsignaturaEstudiantesTab({
    super.key,
    this.asignatura,
  });

  @override
  State<AsignaturaEstudiantesTab> createState() => _AsignaturaEstudiantesTabState();
}

class _AsignaturaEstudiantesTabState extends State<AsignaturaEstudiantesTab> {

  AsignaturasRepository _asignaturasRepository = Get.find<AsignaturasRepository>();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppBar(
      title: Text("Estudiantes"),
    ),
    body: PullToRefresh(
      onRefresh: () async => setState(() => {}),
      child: FutureBuilder<List<User>?>(
        future: () async {
          return (await _asignaturasRepository.getDetalleAsignatura(widget.asignatura))?.estudiantes;
        }(),
        builder: (ctx, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: LoadingIndicator(),
                    ),
                  ),
                ],
              ),
            );
          }

          List<User>? estudiantes = snapshot.data;
          if(snapshot.hasError || !snapshot.hasData || estudiantes == null) {
            return Center(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: CustomErrorWidget(
                  emoji: "\u{1F622}",
                  title: (snapshot.error is CustomException ? (snapshot.error as CustomException).message : "Ocurrió un error al obtener los estudiantes"),
                ),
              ),
            );
          }

          return ListView.separated(
            itemCount: estudiantes.length,
            separatorBuilder: (context, index) => Divider(
              height: 5,
              indent: 20,
              endIndent: 20,
            ),
            itemBuilder: (context, i)  => ListTile(
              title: Text(estudiantes[i].nombreCompletoCapitalizado),
              subtitle: Text(estudiantes[i].correoUtem ?? ''),
              onTap: () {
                showModalBottomSheet(context: context, builder: (ctx) => UserModal(
                  user: estudiantes[i],
                ));
                AnalyticsService.logEvent('asignatura_estudiante_tap', parameters: {
                  'asignatura': widget.asignatura?.codigo,
                  'estudiante': estudiantes[i].correoUtem,
                });
              },
            ),
          );
        },
      ),
    ),
  );
}
