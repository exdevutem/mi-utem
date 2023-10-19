import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/user_controller.dart';
import 'package:mi_utem/models/lunch_coupon.dart';
import 'package:mi_utem/models/usuario.dart';
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
    ever<Usuario?>(
      Get.find<UserController>().user,
      (carrera) => getBenefit(),
    );

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

      final lunchBenefit = LunchBenefit(
        coupons: coupons,
        hasBenefit: true,
      );

      change(
        lunchBenefit,
        status: RxStatus.success(),
      );
    } on DioError catch (e) {
      log("LunchBenefitController catch DioError ${e.toString()}");
      final response = e.response;
      if (response != null && response.statusCode == 404) {
        final lunchBenefit = LunchBenefit(
          coupons: [],
          hasBenefit: false,
        );

        change(
          lunchBenefit,
          status: RxStatus.success(),
        );
      }
    } catch (e) {
      log("LunchBenefitController catch ${e.toString()}");
      change(
        null,
        status: RxStatus.error(e.toString()),
      );
    } finally {
      _setRoleToUser();
    }
  }

  void _setRoleToUser() {
    UserController.to.updateLunchBenefitRole(state);
  }
}
