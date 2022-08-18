import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vangelis/services/theme_service.dart';
import '../config/config.dart';
import '../util/constants.dart';
import '../util/enums.dart';

class ProgressService extends GetxService {
  BuildContext? _pageContext;
  BuildContext? _dialogContext;
  bool _isVisible = false;
  Timer? _timer;

  void _timeOut() async {
    _timer = Timer(Duration(seconds: Configuration().getRequestTimeout()), () {
      if (_isVisible) {
        _isVisible = false;
        if (Navigator.canPop(_dialogContext!)) {
          dismissProgress();
          showMsg(
            type: MessageType.error,
            title: errorMessageTitle,
            message: errorLoadingTimeout,
          );
        }
      }
    });
  }

  ///show loading dialog
  void showProgress({bool showBackground = true}) {
    if (Get.context != null) {
      _isVisible = true;
      _pageContext = Get.context!;
      _timeOut();
      FocusScope.of(_pageContext!).requestFocus(FocusNode());
      showGeneralDialog(
        context: _pageContext!,
        barrierColor: showBackground
            ? themeConfig!.whiteBlackColor
            : themeConfig!.blackWhiteColor.withOpacity(0.3),
        barrierDismissible: false,
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          _dialogContext = context;
          return Stack(
            children: [
              if (showBackground)
                Image.asset(
                  themeConfig!.bgWhiteAsset,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
              Center(
                child: Image.asset(
                  themeConfig!.loadingGif,
                  width: Get.width * 0.6,
                  fit: BoxFit.cover,
                  semanticLabel: barbriLogo,
                ),
              ),
            ],
          );
        },
      );
    }
  }

  ///dismiss loading dialog
  void dismissProgress() {
    try {
      _isVisible = false;
      _timer?.cancel();
      if (_dialogContext != null && Navigator.canPop(_dialogContext!)) {
        Navigator.pop(_dialogContext!);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
