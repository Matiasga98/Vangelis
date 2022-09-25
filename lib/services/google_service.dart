import 'dart:convert';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:objectbox/objectbox.dart';
import '../entity/jwt.dart';
import '../entity/user.dart';
import '../model/musician.dart';
import 'base_api_service.dart';
import 'package:http/http.dart' as http;

class GoogleService extends BaseApiService {
  final _getUserUrl = 'users/me';
  final _baseUserUrl = 'users';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/youtube.readonly',
    ],
  );

  GoogleSignInAccount? _currentUser;

  Future<void> handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      //_handleGetChannels();
    } catch (error) {
      var e = error;
    }
  }

  void silentSignIn(){
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _currentUser = account;
    });
    _googleSignIn.signInSilently();
  }

  Future<SearchListResponse> handleGetChannels() async {
    var httpClient = (await _googleSignIn.authenticatedClient())!;
    var youTubeApi = YouTubeApi(httpClient);

    var userChannel = await youTubeApi.channels.list(['id'], mine: true);
    var userChannelId = userChannel.items?[0].id;

    if (userChannelId != null) {
      var userVideoss = await youTubeApi.search
          .list(['snippet'], channelId: userChannelId, type: ["video"]);
      if (userVideoss.items != null) {
        return userVideoss;
      }
    }
    return SearchListResponse();
  }




}
