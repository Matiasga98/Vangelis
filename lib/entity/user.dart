import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:objectbox/objectbox.dart';
import 'package:vangelis/model/musician.dart';

import '../config/config.dart';
import '../mixins/updatable_entity.dart';
import '../model/Genre.dart';
import '../model/Instrument.dart';
import 'jwt.dart';

@Entity()
class User with UpdatableEntity {
  @Id()
  var objectBoxId = 0;
  var id;
  var userAvatar;
  var bio;
  List<String> userPhotos = [];
  List<Genre> favoriteGenres = [];
  List<Instrument> instruments = [];
  List<int> favoriteUsers = [];

  var userName = '';
  var email = '';
  var phoneNumber = '';
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

  factory User({Map<String, dynamic>? json, Jwt? token}) {
    if (json != null) {
      _singleton.id = json["id"] ?? _singleton.id;
      _singleton.bio = json["bio"] ?? _singleton.bio;
      _singleton.userAvatar = json["userAvatar"] ?? _singleton.userAvatar;
      _singleton.userName = json['username'] ?? _singleton.userName;
      _singleton.email = json['email'] ?? _singleton.email;
      _singleton.phoneNumber = json['phoneNumber'] ?? _singleton.phoneNumber;
      _singleton.instruments = json['instruments'] != null
          ? [
              for (var instrument in json['instruments'])
                Instrument.fromJson(instrument)
            ]
          : [];
      _singleton.favoriteGenres = json['favoriteGenres'] != null
          ? [
              for (var favoriteGenre in json['favoriteGenres'])
                Genre.fromJson(favoriteGenre)
            ]
          : [];
      _singleton.favoriteUsers = json["favorite_users"] != null
          ? json["favorite_users"].cast<int>()
          : [];
      _singleton.favoriteUsers;

      _singleton.userPhotos = json["photos"] != null
          ? [for (var photo in json['photos']) photo['image']]
          : [];

      _singleton.isDark = Get.isDarkMode;
    }
    _singleton.token =
        token != null ? ToOne<Jwt>(target: token) : _singleton.token;
    return _singleton;
  }

  Musician musicianFromUser() {
    return Musician(id, userAvatar, bio, favoriteGenres, instruments, userName,
        email, phoneNumber, userPhotos);
  }

  Image imageFromUserBase64String() {
    return Image.memory(base64Decode(userAvatar));
  }

  List<Image> photosFromUserBase64String() {
    List<Image> photosImages = <Image>[];
    for (var photo in userPhotos) {
      photosImages.add(Image.memory(base64Decode(photo)));
    }
    return photosImages;
  }

  User._internal();

  void clearUserData() {
    //_singleton.firstName = '';
    //_singleton.lastName = '';
    //_singleton.partyId = 0;
    _singleton.userName = '';
    _singleton.email = '';
    _singleton.phoneNumber = '';
    _singleton.defaultLocale = Platform.localeName;
    _singleton.isDark = Get.isDarkMode;
    _singleton.objectBoxId = 0;
    _singleton.token = ToOne<Jwt>(target: Jwt.parameterized(''));

    //ToOne<Jwt>(target: Jwt.parameterized('', '', '', 0, '', ''));
  }

  User.fromJson(Map<String, dynamic> json)
      : bio = json["bio"] ?? _singleton.bio,
        userAvatar = json["userAvatar"] ?? _singleton.userAvatar,
        userName = json['username'] ?? _singleton.userName,
        email = json['email'] ?? _singleton.email,
        phoneNumber = json['phoneNumber'] ?? _singleton.phoneNumber,
        instruments = json['instruments'] != null
            ? [
                for (var instrument in json['instruments'])
                  Instrument.fromJson(instrument)
              ]
            : [],
        favoriteGenres = json['favoriteGenres'] != null
            ? [
                for (var favoriteGenre in json['favoriteGenres'])
                  Genre.fromJson(favoriteGenre)
              ]
            : [],
        favoriteUsers =
            json["favorite_users"].cast<int>() ?? _singleton.favoriteUsers,
        userPhotos = json["photos"] != null
            ? [for (var photo in json['photos']) photo['image']]
            : [];

  Map<String, dynamic> toJson() => {
        //'firstName': _singleton.firstName,
        //'lastName': _singleton.lastName,
        //'partyId': _singleton.partyId,
        'id': _singleton.id,
        'username': _singleton.userName,
        'email': _singleton.email,
        'phoneNumber': _singleton.phoneNumber,
        'defaultLocale': _singleton.defaultLocale,
        'isDark': _singleton.isDark,
        'environment': _singleton.environment,
        'token': _singleton.token
      };
}
