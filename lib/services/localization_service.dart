import 'dart:ui';
import 'package:get/get.dart';
import '../entity/user.dart';
import '../lang/en_us.dart';
import '../lang/es_ar.dart';
import '../repository/storage/user_storage.dart';

class LocalizationService extends Translations {
  final UserStorage _userStorage = Get.find();

  static const locale = Locale('en', 'US');
  static const fallbackLocale = Locale('en', 'US');

  static final languages = [
    'English (United States)',
    'Español (Argentina)',
  ];

  static final _locales = {
    'en_US': const Locale('en', 'US'),
    'es_AR': const Locale('es', 'AR'),
  };

  static List<Locale> getLocales() {
    return List.from(_locales.values);
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'es_AR': esAR,
      };

  Future<bool> changeLocale(Locale locale) async {
    try {
      User().defaultLocale = locale.toString();
      await _userStorage.saveUser(User());
      Get.updateLocale(locale);
      return true;
    } catch (e) {
      return false;
    }
  }

  Locale _getLocaleFromString(String locale) {
    Locale? selected = LocalizationService._locales[locale];
    return selected ?? LocalizationService.fallbackLocale;
  }

  void setUpLocaleFromUser() {
    final localeString = User().defaultLocale;
    final userLocale = _getLocaleFromString(localeString);
    Get.updateLocale(userLocale);
  }
}
