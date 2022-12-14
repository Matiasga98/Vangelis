import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:vangelis/model/musician.dart';
import 'package:vangelis/util/constants.dart';

import 'Genre.dart';
import 'Instrument.dart';
import 'collab_response.dart';

class Collab {
  int id;
  String videoId;
  String title;
  String description;
  Musician musician;
  List<Genre> genres;
  List<Instrument> instruments;
  List<CollabResponse> responses;
  bool isOpen;

  Collab(this.id, this.videoId, this.title, this.description, this.genres,
      this.instruments, this.musician, this.responses, this.isOpen);

  Collab.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        videoId = json['media']["mediaUrl"],
        description = json['description'],
        title = json['title'],
        isOpen = json['open'],
        musician = Musician.fromJson(json['user']),
        responses = json['responses'] != null
            ? [
                for (var response in json['responses'])
                  CollabResponse.fromJson(response)
              ]
            : [],
        instruments = json['instruments'] != null
            ? [
                for (var instrument in json['instruments'])
                  Instrument.fromJson(instrument)
              ]
            : [],
        genres = json['genres'] != null
            ? [
                for (var favoriteGenre in json['genres'])
                  Genre.fromJson(favoriteGenre)
              ]
            : [];
}
