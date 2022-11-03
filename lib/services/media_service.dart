import 'base_api_service.dart';
import 'dart:convert';
import '../entity/user.dart';


class MediaService extends BaseApiService {
  final _baseMediaUrl = 'media';

  @override
  Future<User?> uploadVideos(List<String> videos) async {
    var data = {
      'stringList': videos,
    };
    try{
      var response = await post('$_baseMediaUrl/YT/user',data);
      if(BaseApiService.isSuccessful(response)){
        var userJson = json.decode(utf8.decode(response.bodyBytes));
        return User.fromJson(userJson);
      }
    }
    catch(e){
    }
    return null;
  }

  @override
  Future<User?> removeVideo(int id) async {
    try{
      var data = {
        'bio': id,
      };
      var url = '$_baseMediaUrl/removeVideo';
      var response = await post(url, data);
      if(BaseApiService.isSuccessful(response)){
        var userJson = json.decode(utf8.decode(response.bodyBytes));
        return User.fromJson(userJson);
      }
    }
    catch(e){
    }
    return null;
  }
}
