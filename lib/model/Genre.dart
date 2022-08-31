import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:vangelis/util/constants.dart';


class Genre{
  int id;
  var icon;
  String name;

  Genre.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        icon = json['icon'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'icon': icon,
    'name': name,
  };

  Image imageFromBase64String() {
    return Image.memory(base64Decode(icon),
      width: 90.w,);
  }


}