import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:vangelis/util/constants.dart';

import 'Genre.dart';
import 'Instrument.dart';


class Collab{
  int id;
  String videoId;
  String title;
  String description;
  List<Genre> genres;
  List<Instrument> instruments;




  Collab(this.id, this.videoId, this.title, this.description, this.genres,
      this.instruments);

  Collab.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        videoId = json['videoId'],
        description = json['description'],
        title = json['title'],
        instruments = json['instruments'] != null
            ? [
          for (var instrument in json['instruments'])
            Instrument.fromJson(instrument)
        ]
            : [],
        genres = json['favoriteGenres'] != null
            ? [
          for (var favoriteGenre in json['favoriteGenres'])
            Genre.fromJson(favoriteGenre)
        ]
            : [];


}