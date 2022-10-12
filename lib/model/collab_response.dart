import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:vangelis/util/constants.dart';

import 'Genre.dart';
import 'Instrument.dart';


class CollabResponse{
  int id;
  String videoId;
  double startTime;

  List<Genre> genres;
  List<Instrument> instruments;




  CollabResponse(this.id, this.videoId,this.genres, this.instruments,this.startTime);

  CollabResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        videoId = json['videoId'],
        startTime = json['startTime'],
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