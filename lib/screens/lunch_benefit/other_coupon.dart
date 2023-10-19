import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/models/lunch_coupon.dart';
import 'package:mi_utem/themes/theme.dart';

class LunchBenefitOtherCoupon extends StatelessWidget {
  final LunchCoupon coupon;

  const LunchBenefitOtherCoupon({
    Key? key,
    required this.coupon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy');

    return CouponCard(
      height: 120,
      curvePosition: 190,
      curveRadius: 20,
      borderRadius: 10,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      curveAxis: Axis.vertical,
      firstChild: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: MainTheme.grey,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${coupon.status} para el".toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              formatter.format(coupon.validFor),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      secondChild: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Mdi.barcode,
              size: 50,
            ),
            Text(
              coupon.code,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
