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
}
