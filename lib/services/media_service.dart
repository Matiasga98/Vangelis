import 'base_api_service.dart';

class MediaService extends BaseApiService {
  final _baseMediaUrl = 'media';

  @override
  Future<bool> uploadVideos(List<String> videos) async {
    var data = {
      'stringList': videos,
    };
    try{
      var response = await post('$_baseMediaUrl/YT/user',data);
      if (BaseApiService.isSuccessful(response)) {
        return true;
      }
    }
    catch(e){
    }
    return false;
  }
}
