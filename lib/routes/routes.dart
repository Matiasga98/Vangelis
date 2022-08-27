import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:vangelis/pages/register/register_page.dart';
import 'package:vangelis/routes/router_name.dart';

import '../pages/dashboard/dashboard_page.dart';
import '../pages/login/login_page.dart';
import '../pages/splash/splash_page.dart';

class Pages {
  static List<GetPage> pages() {
    return [
      GetPage(
        name: RouterName.splashPageTag,
        page: () => SplashPage(),
      ),
      GetPage(
        name: RouterName.loginPageTag,
        page: () => LoginPage(),
      ),
      GetPage(
        name: RouterName.registerPageTag,
        page: () => RegisterPage(),
      ),
      /*GetPage(
        name: RouterName.changePasswordPageTag,
        page: () => ChangePasswordPage(),
      ),*/
      GetPage(
        name: RouterName.dashboardPageTag,
        page: () => DashboardPage(),
      ),
      /*GetPage(
        name: RouterName.helpPageTag,
        page: () =>  FaqPage(),
      ),*/
    ];
  }
}
