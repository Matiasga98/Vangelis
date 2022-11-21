import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:vangelis/helpers/card_widget.dart';
import 'package:vangelis/helpers/custom_button.dart';
import 'package:vangelis/model/Genre.dart';
import 'package:vangelis/model/Instrument.dart';
import 'package:vangelis/model/collab.dart';
import 'package:vangelis/pages/dashboard/collab/card_widget.dart';
import 'package:vangelis/pages/dashboard/collab/collab_page.dart';
import 'package:vangelis/pages/dashboard/collab/response_card_widget.dart';
import 'package:vangelis/pages/dashboard/video/video_page.dart';
import 'package:vangelis/services/collab_service.dart';
import 'package:vangelis/services/genre_service.dart';
import 'package:vangelis/services/google_service.dart';
import 'package:vangelis/services/instrument_service.dart';
import 'package:vangelis/services/user_service.dart';
import 'package:vangelis/util/constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../entity/user.dart';

class CollabUserController extends GetxController {
  GoogleService googleService = Get.find();
  var textFilterController = TextEditingController();

  RxBool loading = true.obs;
  final Rx<int> currentButtonIndex = 1.obs;
  RxList<Widget> bodies = <Widget>[].obs;
  CollabService collabService = Get.find();




  List<CollabCard> collabs = [];
  List<CollabCard> filteredCollabCards = [];
  List<ResponseCard> responseCards = [];
  List<Collab> filteredCollabs = [];


  List<String> selectedInstruments = [];
  List<String> selectedGenres = [];


  List filteredMusicians = [];

  List<MusicianCard> musicians = [];



  InstrumentService instrumentService = Get.find();
  GenreService genreService = Get.find();
  UserService userService = Get.find();

  @override
  Future<void> onReady() async {
    if (filteredCollabs.isEmpty) {
    filteredCollabs = await collabService.searchCollabs([], [],true);
    filteredCollabCards = filteredCollabs.map((e) =>
        CollabCard(open: e.isOpen, finalImage: e.musician.userAvatar, name: e.musician.userName,
            description: e.description, address: "CABA",instruments: e.instruments.map((i) => i.name).toList(),
            genres: e.genres.map((g) => g.name).toList(), collabInstrument: "instrumento"))
        .toList();
    }
    loading.value = false;
    super.onReady();

  }




  bool _filterGenreList(CollabCard collab){
    return selectedGenres.length<=0? true :
    collab.genres.any((genre) => selectedGenres.contains(genre));
  }
  bool _filterInstrumentList(CollabCard collab){
    return selectedInstruments.length<=0? true :
    collab.instruments.any((instrument) => selectedInstruments.contains(instrument));
  }


  late YoutubePlayerController _videoController;

  Future<void> loadVideo(int index) async {
    _videoController = YoutubePlayerController(
      initialVideoId: filteredCollabs[index].videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        hideThumbnail: true,
        hideControls: true,
      ),
    );
    responseCards = filteredCollabs[index].responses.map((e) => ResponseCard(open: true, finalImage: e.musician.userAvatar, name: e.musician.userName,
        description: "descripcion", address: "CABA",instruments: e.instruments.map((i) => i.name).toList(),
        genres: e.genres.map((g) => g.name).toList(), collabInstrument: "instrumento")).toList();
    await Future.delayed(Duration(seconds: 1));
  }

  void unloadVideo(){
    responseCards = [];
    selectedVideo = SearchResult();
  }

  Widget openVideo(int index) {
    RxDouble _sliderValue = 0.0.obs;
    RxBool isPlaying = true.obs;
    return AlertDialog(
        title: Text('Respuestas'),
        content: Obx(() => SizedBox(
          height: 800.h,
            width: double.maxFinite,
          child: loading.value? Container():
          ListView.builder(
              shrinkWrap: false,
              primary: false,
              itemCount: responseCards.length,
              itemBuilder: (context, index2) =>
                  GestureDetector(
                    onTap: () => {

                      Get.to(VideoScreen(filteredCollabs[index].videoId,
                          filteredCollabs[index].responses[index2].videoId,filteredCollabs[index].id,false,
                          filteredCollabs[index].responses[index2].id, filteredCollabs[index].responses[index2].startTime
                      )),
                    },
                    child: responseCards[index2],
                  )

          )
          ),
        ));
  }

  SearchResult selectedVideo = SearchResult();

  RxList<SearchResult> userVideos = <SearchResult>[].obs;

  Widget showVideoList() {
    googleService.handleSignIn();
    SearchListResponse videos;
    RxInt selectedIndex = (-1).obs;
    Rx<SearchResult> videoSelected = selectedVideo.obs;
    if(userVideos.isEmpty) {
      googleService
          .handleGetChannelsMock()
          .then((value) => {userVideos.value = value.items!});
    }
    return
      Container(
        width: 300.w,
        height: 300.h,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: userVideos.length,
            itemBuilder:(context,index) {
              return
                Obx(() =>
                GestureDetector(
                  onTap: () =>{
                    selectedIndex.value = index,
                    selectedVideo = userVideos[index]
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: selectedIndex.value == index?Border.all(width: 4.0,color: Colors.lightBlue):Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            image: NetworkImage(userVideos[index].snippet!.thumbnails!.high!.url!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 1.0, bottom: 1.0),
                        ),
                      ))));
            }),
      );

  }


  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  void listener() {
    if (!_videoController.value.isFullScreen) {
      _playerState = _videoController.value.playerState;
      _videoMetaData = _videoController.metadata;
    }
  }



}