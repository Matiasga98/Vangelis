import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/config.dart';
import '../../entity/user.dart';
import '../../services/auth_service.dart';
import '../../services/progress_service.dart';
import '../../util/constants.dart';
import '../dashboard/dashboard_controller.dart';


class LoginController extends GetxController {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  RxBool isRememberMe = false.obs;
  RxBool isStartAnimation = false.obs;
  final RxBool isOktaLogin = false.obs;

  AuthService authService = Get.find();
  final Configuration _configuration = Get.find();

  ProgressService progress = Get.find();

  @override
  void onInit() {
    super.onInit();
    isOktaLogin.value = _configuration.getUseOkta();
    Future.delayed(const Duration(milliseconds: 100), () {
      isStartAnimation.value = true;
    });
  }

  @override
  void onReady() {
    if (Get.isRegistered<DashboardController>()) {
      Get.delete<DashboardController>(force: true);
    }
  }

  Future<bool> logIn() async {
    /*User? result;
    if (isOktaLogin.value) {
      result = await authService.logInOkta();
    } else {
      if (validate()) {
        progress.showProgress();
        result = await authService.logIn(
          usernameController.text.toString(),
          passwordController.text.toString(),
        );
        progress.dismissProgress();
      } else {
        return false;
      }
    }
    if (result != null) {

      return true;
    } else {
      showMsg(
        title: errorMessageTitle,
        message: errorCredentials,
      );
      return false;
    }*/
    return true;
  }

  bool validate() {
    if (usernameController.text.toString().isEmpty ||
        passwordController.text.toString().isEmpty) {
      showMsg(title: alert, message: enterUserDetail);
      return false;
    }
    return true;
  }

  void changeEnvironment(String environment) {
    User().environment = environment;
    isOktaLogin.value = _configuration.getUseOkta();
  }

  String getUserEnvironment() {
    return User().environment;
  }

  bool isDebugMode() {
    return _configuration.getDebugMode();
  }

  List<MapEntry<String, String>> getEnvironments() {
    return Configuration.environments.entries.toList();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
