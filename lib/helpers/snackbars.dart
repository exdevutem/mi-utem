import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showDefaultSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    colorText: Colors.white,
    backgroundColor: Get.theme.primaryColor,
    snackPosition: SnackPosition.BOTTOM,
    margin: EdgeInsets.all(20),
  );
}
