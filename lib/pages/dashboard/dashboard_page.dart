import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/custom_text.dart';
import '../../services/theme_service.dart';
import '../../util/constants.dart';
import 'dashboard_controller.dart';


class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);

  final DashboardController dashController = Get.find();

  @override
  Widget build(BuildContext context) {
    ThemeService().init(context);

    return SafeArea(
      child: Obx(
        () => Scaffold(
          body: dashController.bodies.isNotEmpty
              ? dashController.bodies[dashController.currentButtonIndex.value]
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          bottomNavigationBar: _buildNavigationBar(),
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              label: bottomNavBarHome.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.file_download_outlined),
              label: bottomNavBarDownload.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_box),
              label: bottomNavBarAccount.tr,
            ),
          ],
          selectedLabelStyle: const TextStyle(fontFamily: regularFont),
          unselectedLabelStyle: const TextStyle(fontFamily: regularFont),
          selectedItemColor: themeConfig!.blueColor,
          backgroundColor: themeConfig!.whiteBlackColor,
          currentIndex: dashController.currentButtonIndex.value,
          onTap: (value) {
            dashController.connectivityService.currentStatus.value ==
                        ConnectivityResult.none &&
                    value != 1
                ? showMsg(
                    title: noConnection, message: downloadContentAvailable)
                : dashController.currentButtonIndex.value = value;
          },
        ),
        internetConnectionWidget(),
      ],
    );
  }

  Widget internetConnectionWidget() {
    return Obx(
      () => AnimatedContainer(
        height: noInternetHeight.value,
        color: dashController.connectivityService.currentStatus.value ==
                ConnectivityResult.none
            ? themeConfig!.redColor
            : themeConfig!.greenColor,
        duration: const Duration(milliseconds: 500),
        child: _internetUi(),
      ),
    );
  }

  Widget _internetUi() {
    animationTime();
    return Center(
      child: CustomText(
        dashController.connectivityService.currentStatus.value ==
                ConnectivityResult.none
            ? noConnection
            : backOnline,
        textColor: themeConfig!.whiteBlackColor,
        fontSize: 22.h,
        fontFamily: regularFont,
      ),
    );
  }

  void animationTime() async {
    if (dashController.connectivityService.currentStatus.value !=
        ConnectivityResult.none) {
      await Future.delayed(const Duration(seconds: 1));
      noInternetHeight.value = 0;
    } else {
      await Future.delayed(const Duration(milliseconds: 500));
      noInternetHeight.value = 35;
      dashController.currentButtonIndex.value = 1;
    }
  }
}
