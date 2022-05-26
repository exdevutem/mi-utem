import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/screens/usuario_screen.dart';
import 'package:mi_utem/services/docentes_service.dart';
import 'package:mi_utem/utils/debounce.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/profile_photo.dart';

class DocentesScreen extends StatefulWidget {
  DocentesScreen({Key? key}) : super(key: key);

  @override
  _DocentesScreenState createState() => _DocentesScreenState();
}

class _DocentesScreenState extends State<DocentesScreen> {
  Future<List<Usuario>>? _futureDocentes;
  late List<Usuario> _docentes;
  late Debounce d;

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    d = Debounce(Duration(seconds: 1), () {
      _getDocentes(_controller.text);
    });
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'DocentesScreen');
  }

  Future<List<Usuario>> _getDocentes(String nombre,
      [bool refresh = false]) async {
    setState(() {
      _docentes = [];
      _futureDocentes = null;
      _futureDocentes = DocentesService.buscarDocentes(nombre);
    });
    List<Usuario> docentes = await _futureDocentes!;
    setState(() {
      _docentes = docentes;
    });
    return docentes;
  }

  _search(String query) {
    if (query.trim().length > 3) {
      d.schedule();
    } else {
      d.clear();
      setState(() {
        _futureDocentes = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Docentes"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Escribe para buscar un docente",
                  prefixIcon: Icon(Icons.search),
                ),
                keyboardType: TextInputType.name,
                onSubmitted: (query) {
                  _search(query);
                },
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.search,
                controller: _controller,
                onChanged: (query) {
                  _search(query);
                },
              ),
            ),
            Container(height: 20),
            _futureDocentes != null
                ? FutureBuilder<List<Usuario>>(
                    future: _futureDocentes,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return CustomErrorWidget(
                          texto: "Ocurrió un error al obtener los docentes",
                          error: snapshot.error,
                        );
                      } else {
                        if (snapshot.hasData && snapshot.data != null) {
                          if (snapshot.data!.length > 0) {
                            return ListView.separated(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  Divider(height: 5, indent: 20, endIndent: 20),
                              itemBuilder: (BuildContext context, int i) {
                                Usuario docente = _docentes[i];
                                return ListTile(
                                  leading: ProfilePhoto(
                                    usuario: docente,
                                    radius: 20,
                                    editable: false,
                                  ),
                                  title: Text(
                                    docente.nombreCompleto!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(docente.correoUtem ??
                                      docente.correoPersonal ??
                                      ""),
                                  onTap: () async {
                                    await Get.to(
                                      () => UsuarioScreen(
                                          tipo: 2,
                                          query: {"nombre": docente.nombre}),
                                    );
                                  },
                                );
                              },
                              itemCount: _docentes.length,
                            );
                          } else {
                            return CustomErrorWidget(
                              emoji: "🤔",
                              texto:
                                  "Parece que no se encontraron docentes que coincidan con tu búsqueda",
                            );
                          }
                        } else {
                          return Container(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: LoadingIndicator(),
                            ),
                          );
                        }
                      }
                    },
                  )
                : CustomErrorWidget(
                    emoji: "💅",
                    texto: "Escribe para buscar un docente",
                  ),
          ],
        ),
      ),
    );
  }
}
