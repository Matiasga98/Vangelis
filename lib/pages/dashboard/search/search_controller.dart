import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/pages/dashboard/profile/profile_page.dart';
import 'package:vangelis/pages/dashboard/search/search_page.dart';

import '../../../entity/user.dart';
import '../../../helpers/card_widget.dart';
import '../../../model/Genre.dart';
import '../../../model/Instrument.dart';
import '../../../model/musician.dart';
import '../../../services/genre_service.dart';
import '../../../services/instrument_service.dart';
import '../../../services/theme_service.dart';
import '../../../services/user_service.dart';
import '../profile/profile_controller.dart';


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
      description: "Bandoneonista", address: "Munro", instruments: ["Bandoneon"],
      genres: ["Rock","Folclore","Chamame"]),
    MusicianCard(finalImage: "images/Indio Diego.png", name: "Diego Daniel Gagliardi", description: "Baterista",
        address: "Ituzaingo", instruments: ["Bateria"], genres: ["Rock","Metal","Pop"]),
    MusicianCard(finalImage: "images/Mantecolati.png", name: "Matias Gamal Laye Berardi",
        description: "Pianista", address: "Villa del Parque", instruments: ["Piano"],
        genres: ["Rock","Metal","Jazz"])
  ];
  List<MusicianCard> filteredMusicianCards = [];
  List<String> selectedInstruments = [];
  List<String> selectedGenres = [];
  List<Instrument> wholeInstruments = [];
  List<Genre> wholeGenres =[];
  List<Musician> filteredMusicians = [];

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
      filteredMusicianCards = [];
      List<Instrument> filteredInstruments = wholeInstruments.where((element)
      => selectedInstruments.contains(element.name)).toList();
      List<Genre> filteredGenres = wholeGenres.where((element)
      => selectedGenres.contains(element.name)).toList();
      filteredMusicians = await userService.searchUsers(filteredGenres.map((genre)=>genre.id).toList(),
          filteredInstruments.map((instrument)=>instrument.id).toList(), "");
      for (Musician musician in filteredMusicians){
        filteredMusicianCards.add(MusicianCard(finalImage: musician.userAvatar??"", name: musician.userName,
            description: "musician.instruments[0].name", address: "musician.favoriteGenres[0].name",
            instruments: musician.instruments.map((a)=>a.name).toList(),
            genres: musician.favoriteGenres.map((a)=>a.name).toList()));
      }
    }
    else{
      filteredMusicianCards = musicians.where((musician) =>
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

  void navigateToProfileOfUserIndex(int index){
    Get.delete<ProfileController>();
    Get.to(() =>ProfilePage(filteredMusicians[index]));
  }

}
