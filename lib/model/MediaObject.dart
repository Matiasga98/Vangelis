import 'dart:convert';
import 'package:flutter/widgets.dart';

class MediaObject{
  int id;
  String media;

  MediaObject({required this.id, required this.media});

  MediaObject.imageFromJson(Map<String, dynamic> json)
      : id = json['id'],
        media = json['image'];

  Map<String, dynamic> imageToJson() => {
    'id': id,
    'image': media,
  };

  MediaObject.videoFromJson(Map<String, dynamic> json)
      : id = json['id'],
        media = json['mediaUrl'];

  Map<String, dynamic> videoToJson() => {
    'id': id,
    'mediaUrl': media,
  };

  Image imageFromBase64String() {
    return Image.memory(
        base64Decode(media),
    );
  }


}