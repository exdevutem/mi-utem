import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/services/permisos_covid_service.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PermisoCovidScreen extends StatefulWidget {
  const PermisoCovidScreen({Key? key, required this.permiso,}) : super(key: key);
  
  final PermisoCovid permiso;

  @override
  State<PermisoCovidScreen> createState() => _PermisoCovidScreenState();
}

class _PermisoCovidScreenState extends State<PermisoCovidScreen> {
  late Future<dynamic> _propiedades;

  @override
  void initState() {
    super.initState();
    _propiedades = PermisosCovidService.getDetallesPermiso(widget.permiso.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text("Permiso Covid")),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _propiedades,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              Get.back();
              return Container();
            }
            if (!snapshot.hasData) {
              return Expanded(flex: 1,child: Center(child: LoadingIndicator(),));
            }

            return LoadedScreen(propiedades: snapshot.data);
          },
        ),
      ),
    );
  }
}

class LoadedScreen extends StatelessWidget {
  const LoadedScreen({
    Key? key,
    required this.propiedades,
  }) : super(key: key);

  final dynamic propiedades;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        child: Column(
          children: [
            UsuarioDetalle(
              nombre: propiedades['usuario']['nombreCompleto'],
              rut: propiedades['usuario']['rut'],
            ),
            Divider(thickness: 1, color: Color(0xFFFEEEEE)),
            DetallesPermiso(
              campus: propiedades['campus'],
              dependencias: propiedades['dependencia'],
              jornada: propiedades['jornada'],
              vigencia: propiedades['vigencia'],
              motivo: propiedades['motivo'],
            ),
            Divider(thickness: 1, color: Color(0xFFFEEEEE)),
            Center(
              child: QrImage(
                data: propiedades['codigoQr'],
                size: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              // child: Center(child: Text("Permiso generado el 27/03/2022")),
            ),
          ],
        ),
      ),
    );
  }
}

class UsuarioDetalle extends StatelessWidget {
  const UsuarioDetalle({
    Key? key,
    required this.nombre,
    required this.rut,
  }) : super(key: key);

  final String nombre, rut;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nombre,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF363636),
                  fontSize: 16.0,
                ),
              ),
              Text(rut),
            ],
          ),
        ],
      ),
    );
  }
}

class DetallesPermiso extends StatelessWidget {
  const DetallesPermiso({
    Key? key,
    this.campus,
    this.dependencias,
    this.jornada,
    this.vigencia,
    this.motivo,
  }) : super(key: key);

  final String? campus, dependencias, jornada, vigencia, motivo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BloqueDetalle(top: "Motivo", bottom: motivo),
          if(campus != null && dependencias != null) 
            Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: BloqueDetalle(
                  top: "Campus",
                  bottom: campus,
                ),
              ),
              Flexible(
                child: BloqueDetalle(top: "Dependencias", bottom: dependencias),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  child: BloqueDetalle(top: "Jornada", bottom: jornada)),
              Flexible(
                child: BloqueDetalle(top: "Vigencia", bottom: vigencia),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BloqueDetalle extends StatelessWidget {
  const BloqueDetalle({
    Key? key,
    required this.top,
    this.bottom,
  }) : super(key: key);

  final String top;
  final String? bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            top,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF7F7F7F),
            ),
          ),
          Text(
            bottom ?? "Sin información",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xFF363636),
            ),
          ),
        ],
      ),
    );
  }
}
