import '../models/user.dart';

class InMemoryUsersDataSource {
  final _users = <String, User>{};

  Future<User?> getUserId(String username) async {
    return _users[username];
  }

  Future<User> saveUser(User user) async {
    if (_users.containsKey(user.username)) return _users[user.username]!;

    final createdUser = user.copyWith(id: _users.length + 1);
    _users[user.username] = createdUser;
    return createdUser;
  }
}
