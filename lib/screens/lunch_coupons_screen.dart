import 'package:flutter/material.dart';
import 'package:mi_utem/screens/beca_alimentacion/cupon.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';

class LunchCouponsScreen extends StatelessWidget {
  const LunchCouponsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Beca de alimentación"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BecaAlimentacionCoupon(
              //code: null,
              code: "3N14M3ARCX",
            ),
          ],
        ),
      ),
    );
  }
}
