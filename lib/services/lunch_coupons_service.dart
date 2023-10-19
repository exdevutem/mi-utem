import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/controllers/user_controller.dart';
import 'package:mi_utem/models/lunch_coupon.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';

class LunchCouponsService {
  static final Dio _dio = DioMiUtemClient.authDio;
  static final GetStorage box = GetStorage();

  static Future<List<LunchCoupon>> getAll({bool forceRefresh = false}) async {
    const uri = "/v1/beca-alimentacion";

    final user = UserController.to.user.value;

    log("LunchCouponsService getAll");

    Response response = await _dio.get(
      uri,
      options: buildCacheOptions(
        Duration(days: 300),
        maxStale: Duration(days: 300),
        forceRefresh: forceRefresh,
        subKey: user?.rut?.numero.toString(),
      ),
    );

    return LunchCoupon.fromJsonList(response.data);
  }

  static Future<List<LunchCoupon>> generate(
      {DateTime? from, DateTime? until}) async {
    const uri = "/v1/beca-alimentacion";

    if (from == null) {
      from = DateTime.now();
    }

    if (until == null || until.isBefore(from)) {
      until = from;
    }

    final data = {
      'desde': from.toIso8601String(),
      'hasta': until.toIso8601String(),
    };

    log("LunchCouponsService generate from $from until $until");

    Response response = await _dio.post(
      uri,
      data: data,
    );

    return LunchCoupon.fromJsonList(response.data);
  }
}
