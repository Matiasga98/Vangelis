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

  Future<SearchListResponse> handleGetChannelsMock() async {
    ResourceId idFran = ResourceId(videoId: "cY3XHRIt55U");
    SearchResultSnippet snippetFran = SearchResultSnippet(thumbnails: ThumbnailDetails(high: Thumbnail(url: "https://img.youtube.com/vi/cY3XHRIt55U/hqdefault.jpg")));
    SearchResult videoFran = SearchResult(id: idFran ,snippet: snippetFran);


    ResourceId id = ResourceId(videoId: "omKruLoPi6A");
    SearchResultSnippet snippet = SearchResultSnippet(thumbnails: ThumbnailDetails(high: Thumbnail(url: "https://img.youtube.com/vi/omKruLoPi6A/hqdefault.jpg")));
    SearchResult video1 = SearchResult(id: id ,snippet: snippet);

    ResourceId id2 = ResourceId(videoId: "QIOuTJBwmwM");
    SearchResultSnippet snippet2 = SearchResultSnippet(thumbnails: ThumbnailDetails(high: Thumbnail(url: "https://img.youtube.com/vi/QIOuTJBwmwM/hqdefault.jpg")));
    SearchResult video2 = SearchResult(id: id2 ,snippet: snippet2);

    return SearchListResponse(items: [videoFran,video1,video2]);
  }


}
