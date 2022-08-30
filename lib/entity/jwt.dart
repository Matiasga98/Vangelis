//import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:objectbox/objectbox.dart';

import 'dart:convert';

import 'package:vangelis/entity/user.dart';

@Entity()
class Jwt {
  Jwt();

  @Id()
  var objectBoxId = 0;
  //var userPartyId = User().partyId;
  @Property(type: PropertyType.date)
  var lastUpdatedAt = DateTime.now();
  //var idToken = '';
  var token = '';
  var tokenType = 'Bearer';
  //var refreshToken = '';
  //var expiresIn = 0;
  //@Property(type: PropertyType.date)
  //var expireDate = DateTime.now();
  //var scope = '';
  //var jti = '';

  /*String get username {
    return _usernameFromToken(idToken);
  }*/

  /*Jwt.parameterized(this.token, this.tokenType, this.refreshToken,
      this.expiresIn, this.scope, this.jti);*/
  Jwt.parameterized(this.token);

  Jwt.fromJson(Map<String, dynamic> json)
      : token = json['token']
        //tokenType = json['token_type']
        //refreshToken = json['refresh_token'],
        //expiresIn = json['expires_in'],
        //scope = json['scope'],
        //jti = json['jti'],
        //expireDate = DateTime.now().add(Duration(seconds: json['expires_in']))
   ;

  /*Jwt.fromAuthorizationTokenResponse(AuthorizationTokenResponse response)
      : accessToken = response.accessToken!,
        idToken = response.idToken!,
        tokenType = response.tokenType!,
        refreshToken = response.refreshToken!,
        expiresIn =
            response.accessTokenExpirationDateTime!.millisecondsSinceEpoch,
        scope = _scopesFromToken(response.accessToken!),
        jti = _jtiFromToken(response.accessToken!),
        expireDate = response.accessTokenExpirationDateTime!;

  Jwt.fromRefreshTokenResponse(TokenResponse response)
      : accessToken = response.accessToken!,
        idToken = response.idToken!,
        tokenType = response.tokenType!,
        refreshToken = response.refreshToken!,
        expiresIn =
            response.accessTokenExpirationDateTime!.millisecondsSinceEpoch,
        scope = _scopesFromToken(response.accessToken!),
        jti = _jtiFromToken(response.accessToken!),
        expireDate = response.accessTokenExpirationDateTime!;
*/
  Map<String, dynamic> toJson() => {
        'token': token,
        'token_type': tokenType
        //'refresh_token': refreshToken,
        //'expires_in': expiresIn,
        //'expire_date': expireDate,
        //'scope': scope,
        //'jti': jti
      };
}

String _scopesFromToken(String token) {
  final parts = token.split('.');
  return parts[1];
}

String _jtiFromToken(String token) {
  final parts = token.split('.');
  return parts[1];
}

String _usernameFromToken(String idToken) {
  return _getFromUserPart(idToken, 'preferred_username');
}

dynamic _getFromUserPart(String token, String fieldName) {
  var part = token.split('.')[1];
  if (part.length % 4 > 0) {
    part += '=' * (4 - part .length % 4);
  }
  final decoded = utf8.fuse(base64).decode(part);
  final obj = json.decode(decoded);
  return obj[fieldName];
}
