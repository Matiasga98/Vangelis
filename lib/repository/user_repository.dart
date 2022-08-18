import 'package:get/get.dart';

import 'package:vangelis/repository/storage/user_storage.dart';

import '../entity/jwt.dart';
import '../entity/user.dart';
import '../services/user_service.dart';
import 'base_repository.dart';

class UserRepository extends BaseRepository {
  final UserService _userService = Get.find();
  final UserStorage _userStorage = Get.find();

  Future<User?> getUser(String username, [Jwt? token]) async {
    User? result = await _userStorage.getCurrentUser();
    if (shouldGetFromApi(result)) {
      result = await _userService.getUser(username, token);
      if (result != null) {
        result.setLastUpdated();
        await _userStorage.saveUser(result);
      }
    }
    return result;
  }

  Future<User?> getCurrentUser({bool forceApi = false}) async {
    User? result = await _userStorage.getCurrentUser();
    if (shouldGetFromApi(result, forceApi)) {
      result = await _userService.getCurrentUser();
      if (result != null) {
        result.setLastUpdated();
        await _userStorage.saveUser(result);
      }
    }
    return result;
  }
}
