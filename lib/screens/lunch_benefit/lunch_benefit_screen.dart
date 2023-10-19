import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/lunch_coupons_controller.dart';
import 'package:mi_utem/screens/lunch_benefit/other_coupon.dart';
import 'package:mi_utem/screens/lunch_benefit/today_coupon.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';

class LunchBenefitScreen extends GetView<LunchBenefitController> {
  const LunchBenefitScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Beca de alimentación"),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: controller.obx(
          (lunchBenefit) {
            if (lunchBenefit == null) {
              return _ErrorView(error: "No se pudo obtener");
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LunchBenefitTodayCoupon(
                  todayCoupon: lunchBenefit.todayCoupon,
                ),
                SizedBox(height: 20),
                Text(
                  "Próximos cupones".toUpperCase(),
                  style: Get.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ListView.separated(
                  itemCount: lunchBenefit.otherAvailableOrderedCoupons.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final coupon =
                        lunchBenefit.otherAvailableOrderedCoupons[index];

                    return LunchBenefitOtherCoupon(coupon: coupon);
                  },
                ),
              ],
            );
          },
          onError: (error) => _ErrorView(error: error),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    Key? key,
    required this.error,
  }) : super(key: key);

  final String? error;

  @override
  Widget build(BuildContext context) {
    return Text(error.toString());
  }
}
