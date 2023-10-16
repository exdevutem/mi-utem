import 'package:get/get.dart';
import 'package:mi_utem/models/lunch_coupon.dart';
import 'package:mi_utem/services/lunch_coupons_service.dart';

class LunchCouponsController extends GetxController
    with StateMixin<List<LunchCoupon>> {
  static LunchCouponsController get to => Get.find();

  @override
  void onInit() {
    change(null, status: RxStatus.loading());

    getCoupons();
    super.onInit();
  }

  void getCoupons() async {
    change(null, status: RxStatus.loading());

    List<LunchCoupon> response = await LunchCouponsService.getAll();

    change(response, status: RxStatus.success());
  }
}
