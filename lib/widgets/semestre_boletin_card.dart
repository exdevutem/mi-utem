import 'package:flutter/material.dart';

class SemestreBoletinCard extends StatelessWidget {
  final String? semestre;
  final int? aprobados;
  final int? reprobados;
  final int? convalidados;
  final double? promedio;
  final List? ramos;

  SemestreBoletinCard(
      {Key? key,
      this.semestre,
      this.aprobados,
      this.reprobados,
      this.convalidados,
      this.promedio,
      this.ramos})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    child: Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                color: Color(0xFFD8BFD8),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    children: [
                      Text("Promedio",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      Text(promedio.toString(),
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                color: Color(0xFF98FB98),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    children: [
                      Text("Aprobados",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      Text(aprobados.toString(),
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                color: Color(0xFFFFC0CB),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    children: [
                      Text("Reprobados",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      Text(reprobados.toString(),
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Color(0xFFFFDEAD),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    children: [
                      Text("Convalidados",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      Text(convalidados.toString(),
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text("Asignatura",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text("Estado",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Text("Nota",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              new ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: ramos!.length,
                separatorBuilder: (BuildContext context, int i) => Divider(
                  indent: 20,
                  endIndent: 20,
                ),
                itemBuilder: (BuildContext context, int i) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(ramos![i]["nombre"],
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text(ramos![i]["estado"].substring(0, 1),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Text(ramos![i]["nota"].toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      color: Colors.white,
    ),
  );
}
