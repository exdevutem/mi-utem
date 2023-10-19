import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/lunch_coupon.dart';
import 'package:mi_utem/services/lunch_coupons_service.dart';

class LunchBenefit {
  final List<LunchCoupon> coupons;
  final bool hasBenefit;

  LunchCoupon? get todayCoupon {
    final now = DateTime.now();
    return coupons.firstWhereOrNull(
      (element) =>
          element.validFor.day == now.day &&
          element.validFor.month == now.month &&
          element.validFor.year == now.year,
    );
  }

  List<LunchCoupon> get otherAvailableOrderedCoupons {
    final now = DateTime.now();
    final otherCoupons =
        coupons.where((element) => element.validFor.isAfter(now)).toList();

    otherCoupons.sort((a, b) => a.validFor.compareTo(b.validFor));
    return otherCoupons;
  }

  LunchBenefit({
    this.coupons = const [],
    required this.hasBenefit,
  });
}

class LunchBenefitController extends GetxController
    with StateMixin<LunchBenefit> {
  static LunchBenefitController get to => Get.find();

  @override
  void onInit() {
    change(null, status: RxStatus.loading());

    getBenefit();
    super.onInit();
  }

  void getBenefit() async {
    log("LunchBenefitController getBenefit");

    change(null, status: RxStatus.loading());

    log("LunchBenefitController getBenefit 2");

    try {
      final coupons = await LunchCouponsService.getAll();
      log("LunchBenefitController coupons ${coupons.length}");
      change(
        LunchBenefit(
          coupons: coupons,
          hasBenefit: true,
        ),
        status: RxStatus.success(),
      );
    } on DioError catch (e) {
      log("LunchBenefitController catch DioError ${e.toString()}");
      final response = e.response;
      if (response != null && response.statusCode == 404) {
        change(
          LunchBenefit(
            coupons: [],
            hasBenefit: false,
          ),
          status: RxStatus.success(),
        );
      }
    } catch (e) {
      log("LunchBenefitController catch ${e.toString()}");
      change(
        null,
        status: RxStatus.error(e.toString()),
      );
    }
  }
}
