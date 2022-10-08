import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:vangelis/util/constants.dart';

import 'Genre.dart';
import 'Instrument.dart';

class Musician {
  var id;
  var userAvatar;
  var bio;
  List<Genre> favoriteGenres = [];
  List<Instrument> instruments = [];
  var userName = '';
  var email = '';
  var phoneNumber = '';

  Musician.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userName = json['username'],
        bio = json['bio'],
        userAvatar = json['userAvatar'],
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
        email = json['email'],
        phoneNumber = json['phoneNumber'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': userName,
        'email': email,
        'phoneNumber': phoneNumber,
        'bio': bio,
        'userAvatar': userAvatar,
        'instruments': instruments,
        'favoriteGenres': favoriteGenres
      };

  Image imageFromUserBase64String() {
    return Image.memory(base64Decode(userAvatar));
  }

  Musician(this.id, this.userAvatar, this.bio, this.favoriteGenres,
      this.instruments, this.userName, this.email, this.phoneNumber);
}
