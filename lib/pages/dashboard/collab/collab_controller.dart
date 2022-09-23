import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/pages/dashboard/collab/collab_page.dart';

import '../../../entity/user.dart';
import '../../../services/theme_service.dart';
import 'card_widget.dart';

class CollabController extends GetxController {
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
    "Kpop",
    "Eurobeat",
  ];
  List<CollabCard> collabs = [
    CollabCard(open: true, finalImage: "images/Hernan.png", name: "Hernan Ezequiel Rodriguez Cary",
        description: "Bandoneonista", address: "Munro", instruments: ["Bandoneon"],
        genres: ["Rock","Folclore","Chamame"], collabInstrument: "Bateria"),
    CollabCard(open: true, finalImage: "images/Indio Diego.png", name: "Diego Daniel Gagliardi", description: "Baterista",
        address: "Ituzaingo", instruments: ["Bateria"], genres: ["Rock","Metal","Pop"], collabInstrument: "Piano"),
    CollabCard(open: true, finalImage: "images/Mantecolati.png", name: "Matias Gamal Laye Berardi",
        description: "Pianista", address: "Villa del Parque", instruments: ["Piano"],
        genres: ["Rock","Metal","Jazz"], collabInstrument: "Bandoneon")
  ];
  List<CollabCard> filteredCollabs = [];
  List<String> selectedInstruments = [];
  List<String> selectedGenres = [];

  void closeContext() {

    textFilterController.clear();

    searchState.value = false;

  }
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
  RxList<String> instruments = [
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
  ].obs;
  RxList<String> musicalGenres = [
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
    "Kpop",
    "Eurobeat",
  ].obs;
  List<MusicianCard> musicians = [
    MusicianCard(finalImage: "images/Hernan.png", name: "Hernan Ezequiel Rodriguez Cary",
        description: "Busca un guitarrista para esta pista de rock progresivo", address: "Munro",
        instruments: ["Guitarra"],genres: ["Rock"]),
    MusicianCard(finalImage: "images/Indio Diego.png", name: "Diego Daniel Gagliardi",
        description: "Busca cualquier instrumento para esta pista de Metal",address: "Ituzaingo",
        instruments: [], genres: ["Metal"]),
    MusicianCard(finalImage: "images/Mantecolati.png", name: "Matias Gamal Laye Berardi",
        description: "Busca una pista de bandoneon", address: "Villa del Parque",
        instruments: ["Bandoneon"], genres: [])
  ];
  List<MusicianCard> filteredMusicians = [];
  List<String> selectedInstruments = [];
  List<String> selectedGenres = [];
  List<Instrument> wholeInstruments = [];
  List<Genre> wholeGenres =[];

  InstrumentService instrumentService = Get.find();
  GenreService genreService = Get.find();
  UserService userService = Get.find();

  @override
  Future<void> onReady() async {
    if(User().environment !="MOBILE"){
      wholeInstruments = await instrumentService.getAllInstruments();
      instruments.value = wholeInstruments.map((e) => e.name).toList();
      wholeGenres = await genreService.getAllGenres();
      musicalGenres.value = wholeGenres.map((e) => e.name).toList();
    }

    super.onReady();
  }


  void closeContext() {

    textFilterController.clear();

    searchState.value = false;

  }

  Future<void> openContext() async {

    if(User().environment != "MOBILE"){
      filteredMusicians = [];
      List<Instrument> filteredInstruments = wholeInstruments.where((element)
      => selectedInstruments.contains(element.name)).toList();
      List<Genre> filteredGenres = wholeGenres.where((element)
      => selectedGenres.contains(element.name)).toList();
      List<Musician> musicians = await userService.searchUsers(filteredGenres.map((genre)=>genre.id).toList(),
          filteredInstruments.map((instrument)=>instrument.id).toList(), "");
      for (Musician musician in musicians){
        filteredMusicians.add(MusicianCard(finalImage: musician.userAvatar, name: musician.userName,
            description: "hay que cambiar esto", address: "address",
            instruments: musician.instruments.map((a)=>a.name).toList(),
            genres: musician.favoriteGenres.map((a)=>a.name).toList()));
      }
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

    if(User().environment != "MOBILE"){
      //filteredMusicians = todo: llamada al back que me traiga usuarios
    }
    else{
      filteredCollabs = collabs.where((musician) =>
      musician.name.contains(textFilterController.text)
          && _filterGenreList(musician) && _filterInstrumentList(musician)
      ).toList();

    }

    searchState.value = true;

  }
  bool _filterGenreList(CollabCard collab){
    return selectedGenres.length<=0? true :
    collab.genres.any((genre) => selectedGenres.contains(genre));
  }
  bool _filterInstrumentList(CollabCard collab){
    return selectedInstruments.length<=0? true :
    collab.instruments.any((instrument) => selectedInstruments.contains(instrument));
  }

}