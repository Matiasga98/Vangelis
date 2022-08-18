

import '../../entity/jwt.dart';
import '../../entity/user.dart';
import '../../objectbox.g.dart';
import 'base_storage.dart';

class UserStorage extends BaseStorage {
  @override
  Future<User?> getUser(String username, [Jwt? token]) async {
    return await getCurrentUser();
  }

  @override
  Future<User?> getCurrentUser() async {
    var user = User();
    if (user.userName.isNotEmpty) {
      return user;
    } else {
      return await _getFromDatabase();
    }
  }

  Future<User?> _getFromDatabase() async {
    final box = await getBox<User>();
    final query = box.query(User_.firstName.notEquals('')).build();
    List<User>? user = query.find();
    query.close();
    return user.isNotEmpty ? user.first : null;
  }



  Future<void> saveUser(User user) async {
    final box = await getBox<User>();
    box.put(user);
  }

  Future<Jwt> updateToken(Jwt token) async {
    final box = await getBox<Jwt>();
    box.removeAll();
    box.put(token);
    return token;
  }


}
