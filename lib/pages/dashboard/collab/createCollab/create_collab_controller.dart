import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:vangelis/entity/user.dart';
import 'package:vangelis/model/Genre.dart';
import 'package:vangelis/model/Instrument.dart';
import 'package:vangelis/model/collab.dart';
import 'package:vangelis/model/musician.dart';
import 'package:vangelis/pages/dashboard/collab/collab_page.dart';
import 'package:vangelis/services/collab_service.dart';
import 'package:vangelis/services/genre_service.dart';
import 'package:vangelis/services/google_service.dart';
import 'package:vangelis/services/instrument_service.dart';
import 'package:vangelis/services/user_service.dart';



class CreateCollabController extends GetxController {

  GoogleService googleService = Get.find();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  RxBool searchState = false.obs;
  RxList<SearchResult> userVideos = <SearchResult>[].obs;
  Rx<SearchResult> selectedUserVideo = SearchResult().obs;
  RxBool videoSelected = false.obs;

  List<String> selectedInstruments = [];
  List<String> selectedGenres = [];

  List<Genre> wholeGenres = [];

  List<Instrument> wholeInstruments= [];

  List filteredMusicians = [];



  void closeContext() {
    searchState.value = false;

  }

  RxList<String> instruments = [''].obs;
  RxList<String> musicalGenres = [''].obs;

  InstrumentService instrumentService = Get.find();
  GenreService genreService = Get.find();
  UserService userService = Get.find();
  CollabService collabService = Get.find();

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

  Future<void> openContext() async {

    if(User().environment != "MOBILE"){
      filteredMusicians = [];
      List<Instrument> filteredInstruments = wholeInstruments.where((element)
      => selectedInstruments.contains(element.name)).toList();
      List<Genre> filteredGenres = wholeGenres.where((element)
      => selectedGenres.contains(element.name)).toList();
      List<Musician> musicians = await userService.searchUsers(filteredGenres.map((genre)=>genre.id).toList(),
          filteredInstruments.map((instrument)=>instrument.id).toList(), "");

      //filteredMusicians = todo: llamada al back que me traiga usuarios
    }
    else{


    }

    searchState.value = true;

  }
  Future<void> openVideos() async {
    try {
      await googleService.handleSignIn();
      SearchListResponse allUserVideos = await googleService.handleGetChannelsMock();
      if (allUserVideos.items!.isNotEmpty) {
        userVideos.value = allUserVideos.items!;
      }
    } catch (error) {
      var a = error;
    }
  }

  void addVideoToSelected(index) {
    selectedUserVideo.value = userVideos[index];
    videoSelected.value = true;
    //todo llamada al back
  }

  Future<bool> createCollab() async {
    //todo: crear clase collab, crear la instancia y llamar al back
    var video = selectedUserVideo.value;
    var genresSelected = wholeGenres.where((e) => selectedGenres.contains(e.name)).toList();
    var instrumentsSelected = wholeInstruments.where((e) => selectedInstruments.contains(e.name)).toList();

    Collab collab = Collab(0, video.id!.videoId!, titleController.text, descriptionController.text,
        genresSelected, instrumentsSelected,User().musicianFromUser());

    return await collabService.createCollab(collab);
  }

}