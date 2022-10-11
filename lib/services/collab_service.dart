import 'dart:convert';
import 'package:vangelis/model/Genre.dart';
import 'package:vangelis/model/collab.dart';
import 'base_api_service.dart';
import 'package:http/http.dart' as http;

class CollabService extends BaseApiService {
  final _baseCollabUrl = 'collabs';

  @override
  Future<List<Collab>> searchCollabs(
      List<int> genres, List<int> instruments) async {

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

      final uri = Uri.parse("${configuration.getApiUrl()}$_baseCollabUrl?$a$b"
      );
      var response =
      await http.get(uri, headers: {"Content-Type": "application/json"});
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
}
