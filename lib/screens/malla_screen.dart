import 'package:flutter/material.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';

class MallaScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Malla"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        scrollDirection: Axis.horizontal,
        child: Image.asset('assets/images/malla.png', height: MediaQuery.of(context).size.height),
      ),
    );
  }
}
