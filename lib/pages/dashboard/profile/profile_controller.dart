import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/avd.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vangelis/pages/dashboard/profile/favorite/favorite_page.dart';

import 'package:vangelis/services/google_service.dart';
import 'package:vangelis/util/constants.dart';
import 'package:vangelis/services/genre_service.dart';

import 'package:googleapis/youtube/v3.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../entity/user.dart';
import '../../../model/Genre.dart';
import '../../../model/Instrument.dart';
import '../../../model/musician.dart';
import '../../../services/instrument_service.dart';
import '../../../services/user_service.dart';

class ProfileController extends GetxController {
  late Musician musician;


  RxString description = "texto".obs;
  RxString phoneNumber = "texto".obs;
  RxString email = "texto".obs;
  final descriptionController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  RxList<Instrument> instruments = <Instrument>[].obs;
  RxList<Genre> genres = <Genre>[].obs;
  Rx<Image> profilePicture =
      Image(image: AssetImage("images/Indio Diego.png")).obs;
  RxString username = "".obs;
  RxBool isLoading = true.obs;
  RxBool isCurrentUser = true.obs;
  RxBool isFavorited = false.obs;
  UserService userService = Get.find();
  GoogleService googleService = Get.find();
  RxList<SearchResult> userVideos = <SearchResult>[].obs;
  RxList<Image> userPhotos = <Image>[].obs;
  RxList<SearchResult> selectedUserVideos = <SearchResult>[].obs;
  InstrumentService instrumentService = Get.find();
  GenreService genreService = Get.find();

  List<Instrument> filteredPossibleInstruments = <Instrument>[];
  List<Instrument> allPossibleInstruments = <Instrument>[];
  Instrument instrumentToAdd = Instrument(icon: null, name: '', id: 0);

  List<Genre> filteredPossibleGenres = <Genre>[];
  List<Genre> allPossibleGenres = <Genre>[];
  Genre genreToAdd = Genre(icon: null, name: '', id: 0);

  File? tempPicture;

  String? greetingMessage;

  @override
  void onReady() {
    //googleService.silentSignIn();
    getProfileInfo();
    getInstruments();
    getGenres();
    descriptionController.text = musician.bio ?? "";
    phoneNumberController.text = musician.phoneNumber;
    emailController.text = musician.email;
    super.onReady();
  }

  Future<void> getProfileInfo() async {
    if (musician.id != User().id) {
      isCurrentUser.value = false;
    } else {
      isCurrentUser.value = true;
    }
    instruments.value = musician.instruments;
    genres.value = musician.favoriteGenres;
    profilePicture.value = musician.imageFromUserBase64String();
    userPhotos.value = musician.photosFromUserBase64String();
    username.value = musician.userName;
    description.value = musician.bio ?? "";
    phoneNumber.value = musician.phoneNumber;
    email.value = musician.email;
    isFavorited.value = musicianIsFavorite();
    greetingMessage = "Hola ${musician.userName}. ¡Vi tu perfil en Vangelis y me gustaria conocerte!";
    await Future.delayed(Duration(milliseconds: 1000), () async {
      isLoading.value = false;
    });
  }

  Future<User?> updateDescription() async {
    User? user = await userService.updateBio(descriptionController.text);
    if (user != null) {
      musician.bio = user.bio;
      description.value = user.bio;
    }
  }

  Future<User?> updatePhoneNumber() async {
    User? user = await userService.updatePhoneNumber(phoneNumberController.text);
    if (user != null) {
      musician.phoneNumber = user.phoneNumber;
      phoneNumber.value = user.phoneNumber;
    }
  }

  Future<User?> updateEmail() async {
    User? user = await userService.updateEmail(emailController.text);
    if (user != null) {
      musician.email = user.email;
      email.value = user.email;
    }
  }

  Future<void> getInstruments() async {
    allPossibleInstruments = await instrumentService.getAllInstruments();
    filterPossibleInstruments();
  }

  void filterPossibleInstruments() {
    filteredPossibleInstruments = allPossibleInstruments
        .where((ins) => !instruments.any((ins2) => ins.id == ins2.id))
        .toList();
    if (filteredPossibleInstruments.isNotEmpty) {
      instrumentToAdd = filteredPossibleInstruments.first;
    } else {
      instrumentToAdd = Instrument(icon: null, name: '', id: 0);
    }
  }

  Future<void> getGenres() async {
    allPossibleGenres = await genreService.getAllGenres();
    filterPossibleGenres();
  }

  void filterPossibleGenres() {
    filteredPossibleGenres = allPossibleGenres
        .where((gen) => !genres.any((gen2) => gen.id == gen2.id))
        .toList();
    if (filteredPossibleGenres.isNotEmpty) {
      genreToAdd = filteredPossibleGenres.first;
    } else {
      genreToAdd = Genre(icon: null, name: '', id: 0);
    }
  }

  Future<void> updateProfilePicture() async {
    if(tempPicture != null){
      User? user = await userService.setUserAvatar(tempPicture!);
      if (user != null) {
        profilePicture.value = user.imageFromUserBase64String();
      }
    }
  }

  Future<void> uploadPhoto() async {
    if(tempPicture != null){
      User? user = await userService.uploadPhoto(tempPicture!);
      if (user != null) {
        userPhotos.value = user.photosFromUserBase64String();
      }
    }
  }

  void onCancelEditDescription() {
    descriptionController.text = description.value;
  }

  void onCancelEditPhoneNumber() {
    phoneNumberController.text = phoneNumber.value;
  }

  void onCancelEditEmail() {
    emailController.text = email.value;
  }

  bool musicianIsFavorite() {
    return User().favoriteUsers.contains(musician.id);
  }

  void addUserToFavorites() {
    User().favoriteUsers.add(musician.id);
    userService.addFavorites(User().favoriteUsers);
    isFavorited.value = true;
  }

  Future<void> addInstrumentToFavorites() async {
    List<Instrument> newInstruments = List.from(instruments);
    newInstruments.addIf(
        !instruments.any((ins) => ins.id == instrumentToAdd.id),
        instrumentToAdd);
    User? user = await userService
        .addInstrumentsToFavourites(newInstruments.map((i) => i.id).toList());
    if (user != null) {
      instruments.value = user.instruments;
      filterPossibleInstruments();
    }
  }

  Future<void> addGenreToFavorites() async {
    List<Genre> newGenres = List.from(genres);
    newGenres.addIf(!genres.any((gen) => gen.id == genreToAdd.id), genreToAdd);
    User? user = await userService
        .addGenresToFavourites(newGenres.map((i) => i.id).toList());
    if (user != null) {
      genres.value = user.favoriteGenres;
      filterPossibleGenres();
    }
  }

  Future<void> removeGenre(int index) async {
    int newGenreId = genres[index].id;
    var newGenres = genres.where((i) => i.id != newGenreId);
    var genresIds = newGenres.map((genre) => genre.id).toList();
    User? user = await userService.addGenresToFavourites(genresIds);
    if (user != null) {
      genres.value = user.favoriteGenres;
      filterPossibleGenres();
    }
  }

  Future<void> removeInstrument(int index) async {
    int newInstrumentId = instruments[index].id;
    var newInstruments = instruments.where((i) => i.id != newInstrumentId);
    var instrumentsIds =
        newInstruments.map((instrument) => instrument.id).toList();
    User? user = await userService.addInstrumentsToFavourites(instrumentsIds);
    if (user != null) {
      instruments.value = user.instruments;
      filterPossibleInstruments();
    }
  }

  void removeUserFromFavorites() {
    User().favoriteUsers.remove(musician.id);
    userService.addFavorites(User().favoriteUsers);
    isFavorited.value = false;
  }

  void optionsButtonClicked(Object? value) {
    switch (value) {
      case "fav":
        Get.to(() => FavoriteScreen());
    }

  }

  Future<void> handleSignIn() async {
    await googleService.handleSignIn();
  }
  Future<SearchListResponse> _handleGetChannels() async {
    return await googleService.handleGetChannelsMock();
  }

  late YoutubePlayerController _videoController;



  Future<void> openVideos() async {
    try {
      await handleSignIn();
      SearchListResponse allUserVideos = await _handleGetChannels();
      if (allUserVideos.items!.isNotEmpty) {
        userVideos.value = allUserVideos.items!;
      }
    } catch (error) {
      var a = error;
    }
  }

  void addVideoToSelected(index) {
    selectedUserVideos.add(userVideos[index]);
    //todo llamada al back
  }

  Future<void> loadVideo(int index) async {
    _videoController = YoutubePlayerController(
      initialVideoId: selectedUserVideos[index].id!.videoId!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        hideThumbnail: true,
        hideControls: true,
      ),
    );
    await Future.delayed(Duration(seconds: 1));
  }

  Widget openVideo(int index) {
    //_videoController.load(userVideos[index].id!.videoId!);
    RxDouble _sliderValue = 0.0.obs;
    RxBool isPlaying = true.obs;
    return AlertDialog(
        title: Text('video'),
        content: Obx(() => Container(
          height: 350.h,
          child: Column(

            children: [
              YoutubePlayer(
                controller: _videoController,
                showVideoProgressIndicator: true,
                onReady: () {
                  _videoController.addListener(listener);
                  _videoController.load(userVideos[index].id!.videoId!);
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
            ],
          ),
        )));
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
