import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../entity/user.dart';


class Configuration extends GetxService {
  static const environments = {
    'RED3': 'Red 3',
    'RED2': 'Red 2',
    'RED': 'Red',
    'STAGE': 'Staging',
    'PROD': 'Production',
  };

  static const defaultEnvironment = 'PROD';


  Map<String, String>? _envMap;

  @override
  void onInit() {
    super.onInit();
    loadFile();
  }

  String _fromSources(String key, String fallback) {
    /*String? value;
    if (_envMap != null) {
      value = _envMap?[key] ?? fallback;
    } else {
      value = dotenv.get(key, fallback: fallback);
    }*/
    return "fran";
  }

  String getApiUrl() {
    final key = '${User().environment}.API_URL';
    var url = _fromSources(key, '');
    return url.endsWith('/') ? url : '$url/';
  }

  String getApiSecret() {
    final key = '${User().environment}.API_SECRET';
    return _fromSources(key, '');
  }

  String getOktaClientId() {
    final key = '${User().environment}.OKTA_CLIENT_ID';
    return _fromSources(key, '');
  }

  String getOktaIssuerUrl() {
    final key = '${User().environment}.OKTA_ISSUER_URL';
    return _fromSources(key, '');
  }

  int getMaxUpdateTime() {
    return  User().updateTime > 0 ? User().updateTime : int.parse(_fromSources('MAX_UPDATE_TIME', '30'));
  }

  bool getDebugMode() {
    return _fromSources('DEBUG_MODE', 'false').toLowerCase() == 'true';
  }

  int getRequestTimeout() {
    return int.parse(_fromSources('REQUEST_TIMEOUT', '30'));
  }

  bool getFeedbackEnabled() {
    return _fromSources('FEEDBACK_ENABLED', 'false').toLowerCase() == 'true';
  }

  bool getUseOkta() {
    return _fromSources('${User().environment}.OKTA_ENABLED', 'false').toLowerCase() ==
        'true';
  }

  String getFeedbackEmail() {
    return _fromSources('FEEDBACK_EMAIL', 'MobileApp@barbri.com');
  }

  String getChangePasswordAuthEmail() {
    return _fromSources('CHANGE_PASSWORD_AUTH_USER', '');
  }

  String getChangePasswordAuthPassword() {
    return _fromSources('CHANGE_PASSWORD_AUTH_PASSWORD', '');
  }

  Future<void> loadFile() async {
    //await dotenv.load(fileName: ".env");
  }

  Future<void> forceLoad() async {
    await loadFile();
    _envMap = dotenv.env;
  }
}
