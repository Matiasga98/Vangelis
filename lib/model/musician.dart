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
  List<String> userPhotos = [];
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
        userPhotos = json["photos"] != null
            ? [
                for (var photo in json['photos'])
                  photo['image']
              ]
            : [],
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
        'userPhotos': userPhotos,
        'instruments': instruments,
        'favoriteGenres': favoriteGenres
      };

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

  Musician(
      this.id,
      this.userAvatar,
      this.bio,
      this.favoriteGenres,
      this.instruments,
      this.userName,
      this.email,
      this.phoneNumber,
      this.userPhotos);
}
