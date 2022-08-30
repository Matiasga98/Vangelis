import 'dart:io';

import 'package:get/get.dart';

import 'package:objectbox/objectbox.dart';


import '../config/config.dart';
import '../mixins/updatable_entity.dart';
import 'jwt.dart';

@Entity()
class User with UpdatableEntity {
  @Id()
  var objectBoxId = 0;
  //var firstName = '';
  //var lastName = '';

  //@Unique(onConflict: ConflictStrategy.replace)
  //var partyId = 0;
  var userName = '';
  var email = '';
  var token = ToOne<Jwt>();
  var defaultLocale = 'es_ar';

  @override
  @Property(type: PropertyType.date)
  // ignore: overridden_fields
  var lastUpdatedAt = DateTime.now();
  var environment = Configuration.defaultEnvironment;
  //var updateTime = 0;
  var isDark = false;

  static final User _singleton = User._internal();

  factory User({Map<String, dynamic>? json, Jwt? token})
  {
    if (json != null) {
      //_singleton.firstName = json['firstName'] ?? _singleton.firstName;
      //_singleton.lastName = json['lastName'] ?? _singleton.lastName;
      //_singleton.partyId = json['partyId'] ?? _singleton.partyId;
      _singleton.userName = json['username'] ?? _singleton.userName;
      _singleton.email = json['email'] ?? _singleton.email;
      //_singleton.defaultLocale = Platform.localeName;
      _singleton.isDark = Get.isDarkMode;
    }
    _singleton.token =
        token != null ? ToOne<Jwt>(target: token) : _singleton.token;
    return _singleton;
  }

  User._internal();

  void clearUserData() {
    //_singleton.firstName = '';
    //_singleton.lastName = '';
    //_singleton.partyId = 0;
    _singleton.userName = '';
    _singleton.email = '';
    _singleton.defaultLocale = Platform.localeName;
    _singleton.isDark = Get.isDarkMode;
    _singleton.objectBoxId = 0;
    _singleton.token = ToOne<Jwt>(target: Jwt.parameterized(''));
        //ToOne<Jwt>(target: Jwt.parameterized('', '', '', 0, '', ''));
  }

  Map<String, dynamic> toJson() => {
        //'firstName': _singleton.firstName,
        //'lastName': _singleton.lastName,
        //'partyId': _singleton.partyId,
        'username': _singleton.userName,
        'email': _singleton.email,
        'defaultLocale': _singleton.defaultLocale,
        'isDark': _singleton.isDark,
        'environment': _singleton.environment,
        'token': _singleton.token
      };
}
