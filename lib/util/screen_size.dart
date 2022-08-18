import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenSize {
  static double screenSizeWidthPercentage(double percentage) {
    return (Get.width / 100) * percentage;
  }

  static double screenSizeHeightPercentage(double percentage) {
    return (Get.height / 100) * percentage;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double designHeight = 1280.0;
  if (Get.context != null && Get.context!.orientation == Orientation.portrait) {
    return (inputHeight / designHeight) * Get.height;
  } else {
    return (inputHeight / designHeight) * Get.width;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double designWidth = 720;
  if (Get.context != null && Get.context!.orientation == Orientation.portrait) {
    return (inputWidth / designWidth) * Get.width;
  } else {
    return (inputWidth / designWidth) * Get.height;
  }
}

extension PropotionalHeight on int {
  /// [getter] to get [responsive height] according to device height
  double get h => getProportionateScreenHeight(toDouble());

  /// [getter] to get [responsive width] according to device width
  double get w => getProportionateScreenWidth(toDouble());
}
