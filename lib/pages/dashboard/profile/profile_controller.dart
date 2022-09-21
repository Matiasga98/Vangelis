import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vangelis/pages/dashboard/profile/favorite/favorite_page.dart';
import 'package:vangelis/util/constants.dart';

import 'package:googleapis/youtube/v3.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../entity/user.dart';
import '../../../model/Genre.dart';
import '../../../model/Instrument.dart';
import '../../../model/musician.dart';
import '../../../services/theme_service.dart';
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
  RxList<SearchResult> userVideos = <SearchResult>[].obs;

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

  void updateDescription() {
    description.value = descriptionController.text;
    musician.bio = description.value;
    //todo: llamar al back para editarla
  }

  void onCancel() {
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

  void removeUserFromFavorites() {
    User().favoriteUsers.remove(musician.id);
    userService.addFavorites(User().favoriteUsers);
    isFavorited.value = false;
    //UserService.addToFavorites(musician.id)
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
      var userVideoss = await youTubeApi.search
          .list(['snippet'], channelId: userChannelId, type: ["video"]);
      if (userVideoss.items != null) {
        userVideos.addAll(userVideoss.items!);
      }
    }
  }

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'iLnmTe5Q2Qw',
    flags: YoutubePlayerFlags(
      autoPlay: true,
      mute: true,
    ),
  );

  Widget openVideo(int index)  {

    _controller.load(userVideos[index].id!.videoId!);
    return AlertDialog(
        title: Text('video'),
        content: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {
            _controller.addListener(listener);
            _controller.load(userVideos[index].id!.videoId!);
          },
        )
    );

  }

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;

  void listener() {
    if (!_controller.value.isFullScreen) {
      _playerState = _controller.value.playerState;
      _videoMetaData = _controller.metadata;
    }
  }
}
