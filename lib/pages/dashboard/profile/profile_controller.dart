import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vangelis/pages/dashboard/profile/favorite/favorite_page.dart';
import 'package:vangelis/services/genre_service.dart';

import 'package:googleapis/youtube/v3.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

import '../../../entity/user.dart';
import '../../../model/Genre.dart';
import '../../../model/Instrument.dart';
import '../../../model/musician.dart';
import '../../../services/instrument_service.dart';
import '../../../services/user_service.dart';

class ProfileController extends GetxController {
  late Musician musician;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/youtube.readonly',
    ],
  );

  GoogleSignInAccount? _currentUser;

  RxString description = "texto".obs;
  final descriptionController = TextEditingController();
  RxList<Instrument> instruments = <Instrument>[].obs;
  RxList<Genre> genres = <Genre>[].obs;
  Rx<Image> profilePicture =
      Image(image: AssetImage("images/Indio Diego.png")).obs;
  RxString username = "".obs;
  RxBool isLoading = true.obs;
  RxBool isCurrentUser = true.obs;
  RxBool isFavorited = false.obs;
  UserService userService = Get.find();
  InstrumentService instrumentService = Get.find();
  GenreService genreService = Get.find();

  List<Instrument> filteredPossibleInstruments = <Instrument>[];
  List<Instrument> allPossibleInstruments = <Instrument>[];
  Instrument instrumentToAdd = Instrument(icon: null, name: '', id: 0);

  List<Genre> filteredPossibleGenres = <Genre>[];
  List<Genre> allPossibleGenres = <Genre>[];
  Genre genreToAdd = Genre(icon: null, name: '', id: 0);

  File? tempProfilePicture;

  @override
  void onReady() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _currentUser = account;
    });
    if (_currentUser != null) {
      _handleGetChannels();
    }
    _googleSignIn.signInSilently();
    getProfileInfo();
    getInstruments();
    getGenres();
    descriptionController.text = musician.bio ?? "";
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
    username.value = musician.userName;
    description.value = musician.bio ?? "";
    isFavorited.value = musicianIsFavorite();
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
    if(tempProfilePicture != null){
      User? user = await userService.setUserAvatar(tempProfilePicture!);
      if (user != null) {
        profilePicture.value = user.imageFromUserBase64String();
      }
    }
  }

  void onCancelEditDescription() {
    descriptionController.text = description.value;
  }

  bool musicianIsFavorite() {
    return User().favoriteUsers.contains(musician.id);
  }

  void addUserToFavorites() {
    User().favoriteUsers.add(musician.id);
    userService.addFavorites(User().favoriteUsers);
    isFavorited.value = true;
    //UserService.addToFavorites(musician.id)
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
    //UserService.addToFavorites(musician.id)
  }

  Future pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;
      final imageTemp = File(image.path);
      tempProfilePicture = imageTemp;
      //setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void optionsButtonClicked(Object? value) {
    switch (value) {
      case "fav":
        Get.to(() => FavoriteScreen());
    }
  }

  Future<void> handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      _handleGetChannels();
    } catch (error) {
      var e = error;
    }
  }

  Future<void> _handleGetChannels() async {
    var httpClient = (await _googleSignIn.authenticatedClient())!;
    var youTubeApi = YouTubeApi(httpClient);

    var userChannel = await youTubeApi.channels.list(['id'], mine: true);
    var userChannelId = userChannel.items?[0].id;

    if (userChannelId != null) {
      var userVideos = await youTubeApi.search
          .list(['snippet'], channelId: userChannelId, type: ["video"]);
      var myVideos = userVideos.items;
    }
  }
}
