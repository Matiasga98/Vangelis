import 'dart:convert';
import 'package:objectbox/objectbox.dart';
import '../entity/jwt.dart';
import '../entity/user.dart';
import '../model/musician.dart';
import 'base_api_service.dart';
import 'package:http/http.dart' as http;

class UserService extends BaseApiService {
  final _getUserUrl = 'users/me';
  final _baseUserUrl = 'users';


  @override
  Future<User?> getUser(String username, [Jwt? token]) async {
    var user = User();
    user.token = ToOne<Jwt>(target: token!);
    //final params = <String, String>{'username': username};
    var response = await get(_getUserUrl);
    if (BaseApiService.isSuccessful(response)) {
      var decoded = json.decode(utf8.decode(response.bodyBytes));
      return User(json: decoded, token: token);
    } else {
      return null;
    }
  }

  @override
  Future<User?> getCurrentUser() {
    return Future.value(User());
  }

  @override
  Future<List<Musician>> searchUsers(
      List<int> genres, List<int> instruments, String name) async {
    Map<String, String> data = {
      'name': name,
      'instruments': instruments.toString(),
      'genres': genres.toString()
    };
    try {
      //Uri(path: configuration.getApiUrl()+_baseUserUrl, queryParameters: data);
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

      final uri = Uri.parse("${configuration.getApiUrl()}$_baseUserUrl?username=$name$a$b"
      );
      var response =
          await http.get(uri, headers: {"Content-Type": "application/json"});
      if (BaseApiService.isSuccessful(response)) {
        var decoded = json.decode(utf8.decode(response.bodyBytes));
        List<Musician> musicians = [];
        for (var user in decoded) {
          musicians.add(Musician.fromJson(user));
        }
        return musicians;
      }
    } catch (e) {
      var a = e;
    }
    return [];
  }

  @override
  Future<User?> addGenresToFavourites(List<int> ids) async {
    try{
      var body = {
        "genres" : ids
      };
      var response = await patch(_baseUserUrl+"/genres",body);
      if(BaseApiService.isSuccessful(response)){
        //log algo salio bien
        var userJson = json.decode(utf8.decode(response.bodyBytes));
        var user = User.fromJson(userJson);
        return user;
      }
      else{
        print("hola");
        //log algo salio mal
      }
    }
    catch(e){
      var a = e;
    }

  }

  @override
  Future<void> addFavorites(List<int> ids) async {
    try{
      var body = {
        "longList" : ids
      };
      var response = await patch(_baseUserUrl+"/favorites",body);
      if(BaseApiService.isSuccessful(response)){
        //log algo salio bien
      }
      else{
        //log algo salio mal
      }
    }
    catch(e){
      var a = e;
    }

  }

  @override
  Future<User?> addInstrumentsToFavourites(List<int> ids) async {
    try{
      var body = {
        "longList" : ids
      };
      var response = await patch(_baseUserUrl+"/instruments",body);
      if(BaseApiService.isSuccessful(response)){
        //log algo salio bien
        var userJson = json.decode(utf8.decode(response.bodyBytes));
        return User.fromJson(userJson);
      }
      else{
        //log algo salio mal
      }
    }
    catch(e){
      var a = e;
    }

  }

  @override
  Future<User?> updateBio(String newBio) async {
    try{
      var body = {
        "bio" : newBio
      };
      var response = await patch(_baseUserUrl+"/description",newBio);
      if(BaseApiService.isSuccessful(response)){
        //log algo salio bien
        var userJson = json.decode(utf8.decode(response.bodyBytes));
        return User.fromJson(userJson);
      }
      else{
        //log algo salio mal
      }
    }
    catch(e){
      var a = e;
    }

  }

  @override
  Future<List<Musician>> getFavorites(int id) async {
    var response =await get(_baseUserUrl+"/favorites/$id");

    if(BaseApiService.isSuccessful(response)){
      var decoded = json.decode(utf8.decode(response.bodyBytes));
      List<Musician> musicians = [];
      for (var user in decoded) {
        musicians.add(Musician.fromJson(user));
      }
      return musicians;
    }
    else{
      //log algo salio mal
      return [];
    }
  }
}
