import 'package:barcode_widget/barcode_widget.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/helpers/image.dart';
import 'package:mi_utem/themes/theme.dart';

class BecaAlimentacionCoupon extends StatelessWidget {
  final DateTime? expirationDate;
  final String? code;

  const BecaAlimentacionCoupon({
    Key? key,
    required this.code,
    this.expirationDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(24),
      child: CouponCard(
        height: 250,
        curvePosition: 130,
        curveRadius: 30,
        borderRadius: 10,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        firstChild: Container(
          decoration: BoxDecoration(
            color: MainTheme.primaryColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Activo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '20/09/2023',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        secondChild: Container(
          width: double.maxFinite,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: MainTheme.lightGrey,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 42),
          child: code == null
              ? ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(horizontal: 80),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Generar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: _openBarcode,
                  child: BarcodeWidget(
                    data: code!,
                    barcode: Barcode.code128(),
                    drawText: false,
                  ),
                ),
        ),
      ),
    );
  }

  void _openBarcode() {
    openBarcodeView(
      code!,
      size: Size(500, 200),
      type: Barcode.code128(),
      heroTag: "beca_alimentacion",
    );
  }
}
