import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/pages/dashboard/search/search_page.dart';

import '../../../entity/user.dart';
import '../../../services/theme_service.dart';
import 'card_widget.dart';

class SearchController extends GetxController {
  var textFilterController = TextEditingController();
  RxBool searchState = false.obs;

  double distance = 5;
  List<String> maximumDistance = [
    "1km-",
    "5km-",
    "10km-",
    "15km-",
    "20km-",
    "20km+"
  ];
  int selectedDistance = 1;

  double age = 15;
  List<String> ageRange = [
    "15+",
    "18+",
    "20+",
    "25+",
    "30+",
    "35+",
    "40+",
    "45+",
    "50+",
    "60+",
    "65+"
  ];
  int selectedAge = 0;
  String selectedGender = "Masculino";
  List<String> instruments = [
    "Bajo",
    "Saxo",
    "Clarinete",
    "Guitarra",
    "Bateria",
    "Bandoneon",
    "Vocalista",
    "Teremin",
    "Flauta de Embolo",
    "Acordeon",
  ];
  List<String> musicalGenres = [
    "Rock",
    "Jazz",
    "Metal",
    "Cumbia",
    "Reggae",
    "Blues",
    "Tango",
    "Trap",
    "Pop",
    "Folclore",
    "Chamame",
    "Cuarteto",
    "Rap",
    "Hip Hop",
  ];
  List<MusicianCard> musicians = [
    MusicianCard(finalImage: "images/Hernan.png", name: "Hernan Ezequiel Rodriguez Cary",
      description: "Bandoneonista", address: "Munro", instruments: ["Bandoneon"],
      genres: ["Rock","Folclore","Chamame"]),
    MusicianCard(finalImage: "images/Indio Diego.png", name: "Diego Daniel Gagliardi", description: "Baterista",
        address: "Ituzaingo", instruments: ["Bateria"], genres: ["Rock","Metal","Pop"]),
    MusicianCard(finalImage: "images/Mantecolati.png", name: "Matias Gamal Laye Berardi",
        description: "Pianista", address: "Villa del Parque", instruments: ["Piano"],
        genres: ["Rock","Metal","Jazz"])
  ];
  List<MusicianCard> filteredMusicians = [];
  List<String> selectedInstruments = [];
  List<String> selectedGenres = [];

  void closeContext() {

    textFilterController.clear();

    searchState.value = false;

  }

  void openContext() {

    if(User().environment != "MOBILE"){
      //filteredMusicians = todo: llamada al back que me traiga usuarios
    }
    else{
      filteredMusicians = musicians.where((musician) =>
          musician.name.contains(textFilterController.text)
          && _filterGenreList(musician) && _filterInstrumentList(musician)
      ).toList();

    }

    searchState.value = true;

  }
  bool _filterGenreList(MusicianCard musician){
    return selectedGenres.length<=0? true :
    musician.genres.any((genre) => selectedGenres.contains(genre));
  }
  bool _filterInstrumentList(MusicianCard musician){
    return selectedInstruments.length<=0? true :
    musician.instruments.any((instrument) => selectedInstruments.contains(instrument));
  }

}
