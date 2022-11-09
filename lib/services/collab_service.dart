import 'dart:convert';
import 'package:googleapis/sheets/v4.dart';
import 'package:vangelis/model/collab.dart';
import 'package:vangelis/model/collab_response.dart';
import 'base_api_service.dart';

class CollabService extends BaseApiService {
  final _baseCollabUrl = 'collabs';


  @override
  Future<List<Collab>> searchCollabs(
      List<int> genres, List<int> instruments, bool bringMyCollabs) async {

    try {
      String instrumentString = "";
      for (int i in instruments) {
        instrumentString = instrumentString + i.toString() + ",";
      }
      String genreString = "";
      for(int g in genres){
        genreString = genreString + g.toString() +",";
      }
      String a = instruments.isEmpty?"":"&instruments=$instrumentString";
      String b = genres.isEmpty?"":"&genres=$genreString";
      String c = "&bringMyCollabs=$bringMyCollabs";

      final uri = Uri.parse("$_baseCollabUrl/search?$a$b$c"
      );
      var response =
      await get(uri.toString());
      if (BaseApiService.isSuccessful(response)) {
        var decoded = json.decode(utf8.decode(response.bodyBytes));
        List<Collab> collabs = [];
        for (var collab in decoded) {
          collabs.add(Collab.fromJson(collab));
        }
        return collabs;
      }
    } catch (e) {
      var a = e;
    }
    return [];
  }

  @override
  Future<bool> createCollab(Collab collab) async {
    var data = {
      'title': collab.title,
      'description': collab.description,
      'mediaUrl': collab.videoId,
      'instruments': collab.instruments.map((e) => e.id).toList(),
      'genres': collab.genres.map((e) => e.id).toList(),
      'platform': 'YT'
    };
    try{
      var response = await post(_baseCollabUrl,data);
      if (BaseApiService.isSuccessful(response)) {
        return true;
      }
    }
    catch(e){
      var a = e;
    }
    return false;
  }

  @override
  Future<bool> createCollabResponse(CollabResponse collabResponse, int collabId) async {
    var data = {
      'mediaUrl': collabResponse.videoId,
      'startTime': collabResponse.startTime,
      'instruments': collabResponse.instruments.map((e) => e.id).toList(),
      'genres': collabResponse.genres.map((e) => e.id).toList(),
      'platform': 'YT'
    };
    try{
      var response = await post('$_baseCollabUrl/$collabId',data);
      if (BaseApiService.isSuccessful(response)) {
        return true;
      }
    }
    catch(e){
      var a = e;
    }
    return false;
  }

  @override
  Future<bool> chooseCollabResponseWinner(int collabId, int responseId) async {
    var data = {
      'collabId' : collabId,
      'responseId' : responseId
    };
    try{
      var response = await post('$_baseCollabUrl/winner',data);
      if( BaseApiService.isSuccessful(response)){
        return true;
      }
    }
    catch(e){
      var a = e;
    }
    return false;
  }

  @override
  Future<List<Collab>> getCollabsUserResponded() async{
    try{
      var response = await get('$_baseCollabUrl/responses');
      if( BaseApiService.isSuccessful(response)){
        var decoded = json.decode(utf8.decode(response.bodyBytes));
        List<Collab> collabs = [];
        for (var collab in decoded) {
          collabs.add(Collab.fromJson(collab));
        }
        return collabs;
      }
    }
    catch(e){
      var a = e;
    }
    return [];
  }
}
