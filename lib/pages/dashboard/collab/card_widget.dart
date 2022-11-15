import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/colors_.dart';

class CollabCard extends StatelessWidget {
  CollabCard(
      {Key? key,
      required this.open,
      required this.finalImage,
      required this.name,
      required this.description,
      required this.address,
      required this.instruments,
      required this.genres,
      required this.collabInstrument})
      : super(key: key);

  final String finalImage;
  final String name;
  final String description;
  final String address;
  final List<String> instruments;
  final List<String> genres;
  final String collabInstrument;
  String collabImage = "";
  String collabName = "";
  bool open;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 125,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: greenDark.withOpacity(0.12), width: 1),
          color: Colors.white),
      child: Row(
        children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                Center(
                  child: Text(
                    name.split(" ").first,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
                Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.memory(
                          base64Decode(finalImage),
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                        )))
              ])),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                Center(
                    child: Text(
                  "Estado",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                )),
                Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          open ? "images/Abierto.jpg" : "images/Cerrado.jpg",
                          width: 75,
                          height: 75,
                          fit: BoxFit.fitWidth,
                        )))
              ])),
          Expanded(
              child: Center(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Esta buscando:",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 75,
                width: 75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          getInstrumentNames(),
                          style: TextStyle(fontSize: 12, color: Colors.black),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          getGenreNames(),
                          style: TextStyle(fontSize: 12, color: Colors.black),
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ))),
        ],
      ),
    );
  }

  String getInstrumentNames() {
    String names = " ";
    instruments.forEach((element) {
      names = names + element + ", ";
    });
    names = names.length > 1 ? names.substring(0, names.length - 2) : names;

    return names;
  }

  String getGenreNames() {
    String names = " ";
    genres.forEach((element) {
      names = names + element + ", ";
    });
    names = names.length > 1 ? names.substring(0, names.length - 2) : names;

    return names;
  }
}
