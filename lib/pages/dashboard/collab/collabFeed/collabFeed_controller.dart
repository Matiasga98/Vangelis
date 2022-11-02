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
import 'package:vangelis/pages/dashboard/video/video_page.dart';
import 'package:vangelis/services/collab_service.dart';
import 'package:vangelis/services/genre_service.dart';
import 'package:vangelis/services/google_service.dart';
import 'package:vangelis/services/instrument_service.dart';
import 'package:vangelis/services/user_service.dart';
import 'package:vangelis/util/constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../entity/user.dart';

class CollabFeedController extends GetxController {
  GoogleService googleService = Get.find();
  var textFilterController = TextEditingController();
  RxBool searchState = false.obs;
  final Rx<int> currentButtonIndex = 1.obs;

  final RxBool loading = true.obs;



  List<CollabCard> collabs = [];
  List<CollabCard> filteredCollabCards = [];
  List<Collab> filteredCollabs = [];
  List<String> selectedInstruments = [];
  List<String> selectedGenres = [];

  List<Genre> wholeGenres = [];

  List<Instrument> wholeInstruments= [];

  List filteredMusicians = [];

  List<MusicianCard> musicians = [];




  InstrumentService instrumentService = Get.find();
  GenreService genreService = Get.find();
  UserService userService = Get.find();
  CollabService collabService = Get.find();

  @override
  Future<void> onReady() async {
    if (filteredCollabs.isEmpty) {
      List<int> genresIds = User().favoriteGenres.map((g) => g.id).toList();
      List<int> instrumentsIds = User().instruments.map((i) => i.id).toList();
      filteredCollabs = await collabService.searchCollabs(genresIds, instrumentsIds,false);
      filteredCollabCards = filteredCollabs.map((e) =>
          CollabCard(open: true, finalImage: e.musician.userAvatar, name: e.musician.userName,
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
    await Future.delayed(Duration(seconds: 1));
  }

  void unloadVideo(){
    selectedVideo = SearchResult();
  }

  Widget openVideo(int index) {
    RxDouble _sliderValue = 0.0.obs;
    RxBool isPlaying = true.obs;
    return AlertDialog(
        title: Text('video'),
        content: Obx(() => Container(
          height: 800.h,
          child: Column(
            children: [
              YoutubePlayer(
                controller: _videoController,
                showVideoProgressIndicator: true,
                onReady: () {
                  _videoController.addListener(listener);
                },
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        if (isPlaying.value) {
                          _videoController.pause();
                          isPlaying.value = false;
                        } else {
                          _videoController.play();
                          isPlaying.value = true;
                        }
                      },
                      icon: Icon(
                          isPlaying.value ? Icons.pause : Icons.play_arrow)),
                  IconButton(
                      onPressed: () {
                        var miliseconds =
                        ((_sliderValue.value) * 1000).truncate();
                        _videoController
                            .seekTo(Duration(milliseconds: miliseconds));
                        isPlaying.value = true;
                      },
                      icon: Icon(Icons.refresh)),
                  IconButton(
                      onPressed: () {
                        if (_sliderValue.value < 20.0) {
                          _sliderValue.value += 0.1;
                          String stringValue =
                          _sliderValue.value.toStringAsFixed(2);
                          _sliderValue.value = double.parse(stringValue);
                        }
                      },
                      icon: Icon(Icons.add)),
                  IconButton(
                      onPressed: () {
                        if (_sliderValue.value > 0) {
                          _sliderValue.value -= 0.1;
                          String stringValue =
                          _sliderValue.value.toStringAsFixed(2);
                          _sliderValue.value = double.parse(stringValue);
                        }
                      },
                      icon: Icon(Icons.remove))
                ],
              ),
              showVideoList(),
              CustomButton(
                label: "Elegir video respuesta",
                onTap: () => Get.to(VideoScreen(filteredCollabs[index].videoId,
                selectedVideo.id!.videoId!,filteredCollabs[index].id,true)),
              )
            ],
          ),
        )));
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