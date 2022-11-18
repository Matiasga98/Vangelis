import 'dart:convert';

//import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:vangelis/services/user_service.dart';

import '../config/config.dart';
import '../entity/jwt.dart';
import '../entity/user.dart';
import '../model/refresh_token_data.dart';
import '../repository/storage/db_connection.dart';
import '../repository/storage/user_storage.dart';
import 'base_api_service.dart';

class AuthService extends GetxService
{
  final UserService _userService = Get.find();
  final UserStorage _userStorage = Get.find();
  final Configuration _configuration = Get.find();
  //final FlutterAppAuth _appAuth = const FlutterAppAuth();

  static const _scopes = [
    'openid',
    'profile',
    'email',
    'offline_access',
    'groups',
    'read',
    'write'
  ];

  AuthService();

  final _logInUrl = 'authenticate';
  final _registerUrl = 'register';

  Future<bool> isLogged() async
  {
    final user = await _userStorage.getCurrentUser();
    return user != null && user.userName.isNotEmpty;
  }

  Future<User?> logInOkta() async
  {
    /*try {
      final AuthorizationTokenResponse? result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(_configuration.getOktaClientId(), _callbackUrl,
            issuer: _configuration.getOktaIssuerUrl(),
            scopes: _scopes,
            preferEphemeralSession: Platform.isIOS ? true : false),
      );
      if (_validateToken(authorizationTokenResponse: result)) {
        final parsed = Jwt.fromAuthorizationTokenResponse(result!);
        final user = await _userService.getUser(parsed.username, parsed);
        if (user != null && user.userName.isNotEmpty) {
          await _userStorage.saveUser(user);
        }
        return user;
      } else {
        return null;
      }
    } catch (ex) {
      return null;
    }*/
    return await _userStorage.getCurrentUser();
  }

  bool _validateToken(
      /*{AuthorizationTokenResponse? authorizationTokenResponse,
      TokenResponse? refreshTokenResponse}*/) {
    //final tokenResponse = authorizationTokenResponse ?? refreshTokenResponse;
    /*return tokenResponse != null &&
        tokenResponse.accessToken != null &&
        tokenResponse.refreshToken != null &&
        tokenResponse.accessTokenExpirationDateTime != null &&
        tokenResponse.idToken != null &&
        tokenResponse.tokenType != null;*/
    return true;
  }

  Future<bool> register(String username, String password, String email) async{
    try {
      var data = {
        'userName': username,
        'password': password,
        'email': email,
        'bio': ""
      };
      var response = await http.post(Uri.parse(_configuration.getApiUrl() + _registerUrl),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));
      if (BaseApiService.isSuccessful(response)) {
        return true;
      }
      else{
        return false;
      }
      //return true;
    } catch (ex) {
      return false;
    }
  }


  Future<User?> logIn(String username, String password) async
  {
    try {
      //Map<String, String> headers = <String, String>{};
      //headers['Authorization'] = 'Basic ${_configuration.getApiSecret()}';
      var data = {
        'username': username,
        'password': password
      };
      var response = await http.post(Uri.parse(_configuration.getApiUrl() + _logInUrl),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));

      if (BaseApiService.isSuccessful(response)) {
        final parsed = Jwt.fromJson(json.decode(response.body));
        final user = await _userService.getUser(username, parsed);
        /*if (user != null && user.userName.isNotEmpty) {
          await _userStorage.saveUser(user);
        }
        return user;
      } else {
        return null;
      }*/
        return user;
      }
    } catch (ex) {
      DbConnection.deleteDataFiles();
      return null;
    }
  }

  Future<Jwt?> refreshToken() async
  {
    if (_configuration.getUseOkta()) {
      return await _refreshTokenOkta();
    } else {
      return await _refreshTokenSecurityService();
    }
  }

  Future<Jwt?> _refreshTokenOkta() async {
    /*try {
      final user = User();
      final TokenResponse? result = await _appAuth.token(
        TokenRequest(_configuration.getOktaClientId(), _callbackUrl,
            issuer: _configuration.getOktaIssuerUrl(),
            scopes: _scopes,
            refreshToken: user.token.target!.refreshToken),
      );
      if (_validateToken(refreshTokenResponse: result)) {
        final parsed = Jwt.fromRefreshTokenResponse(result!);
        return await _updateToken(parsed);
      } else {
        return null;
      }
    } catch (ex) {
      return null;
    }*/
    return await new Jwt();
  }

  Future<Jwt> _updateToken(Jwt newToken) async {
    final user = User();
    final token = await _userStorage.updateToken(newToken);
    user.token.target = token;
    await _userStorage.saveUser(user);
    return token;
  }

  Future<Jwt?> _refreshTokenSecurityService() async
  {
    Map<String, String> headers = <String, String>{};
    headers['Content-Type'] = 'application/x-www-form-urlencoded';
    headers['Authorization'] = 'Basic ${_configuration.getApiSecret()}';
    final user = User();
    var response = await http.post(Uri.parse(_configuration.getApiUrl() + _logInUrl),
        headers: headers,
        body: RefreshTokenData(refreshToken: user.token.target!.token).toMap());
    if (BaseApiService.isSuccessful(response)) {
      final parsed = Jwt.fromJson(json.decode(response.body));
      return await _updateToken(parsed);
    } else {
      return null;
    }
  }

  Future<bool> logOut() async
  {
    try {
      User().clearUserData();
      await DbConnection.deleteDataFiles();
      return true;
    } catch (e) {
      return false;
    }
  }

/*Future<EndSessionResponse?> logOutOkta(Jwt token) async {
    final request = EndSessionRequest(
        idTokenHint: token.idToken,
        issuer: _configuration.getOktaIssuerUrl(),
        postLogoutRedirectUrl: _logoutUrl);
    User().clearUserData();
    return _appAuth.endSession(request);
  }*/
}

