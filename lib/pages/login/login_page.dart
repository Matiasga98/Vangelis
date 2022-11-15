import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/config.dart';
import '../../helpers/custom_button.dart';
import '../../helpers/custom_text.dart';
import '../../helpers/custom_text_field.dart';
import '../../routes/router_name.dart';
import '../../services/theme_service.dart';
import '../../util/constants.dart';
import '../dashboard/dashboard_controller.dart';
import '../dashboard/dashboard_page.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final _ctrl = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    ThemeService().init(context);
    return Scaffold(
      backgroundColor: themeConfig!.blueColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Stack(
            children: [
              Image.asset(
                themeConfig!.bgBlueAsset,
                fit: BoxFit.cover,
                height: Get.height,
                width: Get.width,
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _changeEnvironment(),
                      child: Semantics(
                        label: barbriLogo.tr,
                        child: Image.asset(
                          themeConfig!.logoAsset,
                          height: 80.h,
                          fit: BoxFit.fitHeight,
                          color: themeConfig!.whiteBlackColor,
                        ),
                      ),
                    ),
                    Obx(
                      () => AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: _ctrl.isStartAnimation.value ? 50.h : 80.h,
                      ),
                    ),
                    Obx(() => Container(
                          color: themeConfig!.whiteBlackColor,
                          padding: EdgeInsets.symmetric(
                              vertical: 50.h, horizontal: 50.w),
                          margin: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: _getFields(_ctrl.isOktaLogin.value),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getFields(bool isOktaLogin) {
    final fields = <Widget>[];
    fields.addAll([
      GestureDetector(
        onTap: () => _ctrl.secretMatiLogin(),
          child: CustomText(
        "Iniciar Sesión",
        fontSize: 40.h,
        fontFamily: regularFont,
        fontWeight: FontWeight.w400,
        textColor: themeConfig!.blackWhiteColor,
      )),
      SizedBox(height: 30.h)
    ]);
    if (!isOktaLogin) {
      fields.addAll([
        CustomTextField(
          keyValue: "username",
          fontSize: 26.h,
          hint: "Usuario",
          label: "Usuario",
          textEditingController: _ctrl.usernameController,
        ),
        SizedBox(height: 30.h),
        CustomTextField(
          fontSize: 26.h,
          keyValue: "password",
          hint: "Contraseña",
          label: "Contraseña",
          textEditingController: _ctrl.passwordController,
          isPassword: true,
          action: TextInputAction.done,
        ),
        SizedBox(height: 30.h),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _register(),
            ],
          ),
        ),
        SizedBox(height: 30.h),
      ]);
    }
    fields.addAll([
      CustomButton(
        keyValue: "loginButton",
        label: "Iniciar sesión",
        fontSize: 20,
        onTap: () async {
          var res = await _ctrl.logIn();
          if (res) {
            Get.put(DashboardController(), permanent: true);
            Get.off(
              () => DashboardPage(),
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 1500),
            );
          }
        },
      ),
      SizedBox(height: 0.h),
    ]);
    return fields;
  }

  Widget _register() {
    return GestureDetector(
      key: const Key(forgotPasswordGestureDetector),
      onTap: () {
        Get.toNamed(RouterName.registerPageTag);
      },
      child: CustomText(
        "Registrarse",
        fontSize: 22.h,
        textColor: themeConfig!.blueColor,
      ),
    );
  }

  void _changeEnvironment() async {
    if (_ctrl.isDebugMode()) {
      var dialogSelection = Rx<String?>(_ctrl.getUserEnvironment());
      final entries = _ctrl.getEnvironments();
      final dialogResult = await showDialog<String?>(
          context: Get.context!,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: CustomText(selectEnvironment.tr),
              children: <Widget>[
                Container(
                  color: themeConfig!.whiteBlackColor,
                  padding:
                      EdgeInsets.symmetric(vertical: 50.h, horizontal: 50.w),
                  margin: EdgeInsets.symmetric(horizontal: 30.w),
                  height: 550.h,
                  // Change as per your requirement
                  width: 50.w,
                  // Change as per your requirement
                  child: ListView.builder(
                      itemCount: Configuration.environments.length,
                      itemBuilder: (context, position) {
                        return Obx(() => RadioListTile<String>(
                            title: CustomText(entries[position].value),
                            value: entries[position].key,
                            groupValue: dialogSelection.value,
                            onChanged: (String? value) {
                              dialogSelection.value = value;
                            }));
                      }),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                            child: CustomText(cancel.tr),
                            onPressed: () => Get.back(result: null)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                            child: CustomText(ok.tr),
                            onPressed: () =>
                                Get.back(result: dialogSelection.value))
                      ],
                    )
                  ],
                )
              ],
            );
          });
      if (dialogResult != null) {
        _ctrl.changeEnvironment(dialogResult);
      }
    }
  }
}
