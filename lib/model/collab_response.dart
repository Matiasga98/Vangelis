import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:vangelis/util/constants.dart';

import 'Genre.dart';
import 'Instrument.dart';
import 'musician.dart';


class CollabResponse{
  int id;
  String videoId;
  double startTime;
  bool isWinner;

  List<Genre> genres;
  List<Instrument> instruments;
  Musician musician;




  CollabResponse(this.id, this.videoId,this.genres, this.instruments,
      this.startTime, this.musician, this.isWinner);

  CollabResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        videoId = json['media']["mediaUrl"],
        startTime = json['startTime'],
        isWinner = json['winner'],
        musician = Musician.fromJson(json['user']),
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