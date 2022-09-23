import 'dart:convert';
import 'package:vangelis/model/Genre.dart';
import 'base_api_service.dart';

class GenreService extends BaseApiService {
  final _getGenresUrl = 'genres';

  @override
  Future<List<Genre>> getAllGenres() async {
    List<Genre> genres = [];
    var response = await get(_getGenresUrl);
    if (BaseApiService.isSuccessful(response)) {
      var decoded = json.decode(utf8.decode(response.bodyBytes));

      for (var genre in decoded){
        genres.add(Genre.fromJson(genre));
      }
      return genres;
    }
    return [];
  }
}
