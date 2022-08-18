import 'dart:async';
import 'package:get/get.dart';
import '../../model/quote_data.dart';
import '../../services/auth_service.dart';
import '../../util/constants.dart';
import '../dashboard/dashboard_controller.dart';
import '../dashboard/dashboard_page.dart';
import '../login/login_page.dart';

class SplashController extends GetxController {
  late bool? isLoggedIn;
  AuthService authService = Get.find();
  Rx<Quote?> quote = Quote().obs;

  //ContentService contentService = Get.find();

  static const defaultQuoteAuthor = 'Steve Jobs';
  int animationTimer = 3000;

  bool? isInit;

  SplashController({this.isInit});

  @override
  void onInit() {
    if (isInit ?? true) {
      checkLogin();
    }

    super.onInit();
  }

  Future<void> getQuote() async {
    try {
      var res = null; //await contentService.getInspirationalQuote();
      quote.value = res ?? Quote(author: defaultQuoteAuthor, quote: defaultQuote);
    } catch (e) {
      quote.value = Quote(author: defaultQuoteAuthor, quote: defaultQuote);
    }
  }

  void checkLogin() async {
    isLoggedIn = await authService.isLogged();
    await getQuote();
    await startAnimation();
  }

  Future<void> startAnimation() async {
    await Future.delayed(Duration(milliseconds: animationTimer), () async {
      navigate();
    });
  }

  void navigate() async {
    if (isLoggedIn!) {
      if (isInit ?? true) {
        Get.put(DashboardController(), permanent: true);
        Get.off(() => DashboardPage(),
            transition: Transition.fadeIn, duration: const Duration(milliseconds: 800));
      }
    } else {
      Get.off(() => LoginPage(),
          transition: Transition.fadeIn, duration: const Duration(milliseconds: 800));
    }
  }
}
