import 'package:get/get.dart';
import 'package:vangelis/repository/storage/user_storage.dart';
import 'package:vangelis/repository/user_repository.dart';
import 'package:vangelis/services/auth_service.dart';
import 'package:vangelis/services/connectivity_service.dart';
import 'package:vangelis/services/genre_service.dart';
import 'package:vangelis/services/google_service.dart';
import 'package:vangelis/services/instrument_service.dart';
import 'package:vangelis/services/progress_service.dart';
import 'package:vangelis/services/theme_service.dart';
import 'package:vangelis/services/user_service.dart';

import 'config/config.dart';


class DependencyBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeService());
    Get.put(ProgressService());
    Get.put(Configuration());
    Get.put(ConnectivityService());
    Get.put(UserStorage());
    Get.put(UserService());
    Get.put(AuthService());
    Get.put(InstrumentService());
    Get.put(GenreService());
    Get.put(GoogleService());




    Get.put(UserRepository());





  }
}
