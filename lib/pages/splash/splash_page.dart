import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vangelis/pages/splash/splash_controller.dart';
import '../../helpers/custom_text.dart';
import '../../services/theme_service.dart';
import '../../util/constants.dart';

//ignore:must_be_immutable
class SplashPage extends StatelessWidget {
  SplashPage({Key? key}) : super(key: key);
  SplashController ctrl = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    ThemeService().init(context);

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            themeConfig!.bgWhiteAsset,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Center(
            child: Image.asset(
              themeConfig!.loadingGif,
              height: 100,
              fit: BoxFit.cover,
              semanticLabel: vangelisLogo,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (ctrl.quote.value!.quote.isNotEmpty)
                      Divider(
                        color: themeConfig!.offWhiteColor,
                        height: 1,
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomText(
                      ctrl.quote.value!.quote,
                      fontSize: 20,
                      fontFamily: regularFont,
                      textColor: themeConfig!.grayTextColor,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomText(
                      ctrl.quote.value!.author,
                      fontSize: 16,
                      textColor: themeConfig!.grayTextColor,
                      textAlign: TextAlign.center,
                      fontFamily: regularFont,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
