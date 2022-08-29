import 'dart:convert';
import 'package:objectbox/objectbox.dart';
import '../entity/jwt.dart';
import '../entity/user.dart';
import 'base_api_service.dart';

class UserService extends BaseApiService {
  final _getUserUrl = 'users/me';

  @override
  Future<User?> getUser(String username, [Jwt? token]) async
  {
    var user = User();
    user.token = ToOne<Jwt>(target: token!);
    //final params = <String, String>{'username': username};
    var response = await get(_getUserUrl);
    if (BaseApiService.isSuccessful(response)) {
      var decoded = json.decode(response.body);
      return User(json: decoded, token: token);
    } else {
      return null;
    }
  }

  @override
  Future<User?> getCurrentUser() {
    return Future.value(User());
  }
}
