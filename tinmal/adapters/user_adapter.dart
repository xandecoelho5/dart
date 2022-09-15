import '../models/user.dart';

class UserAdapter {
  UserAdapter._();

  static User fromMap(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      username: json['username'] as String,
    );
  }

  static Map<String, dynamic> toMap(User user) {
    return {
      'id': user.id,
      'username': user.username,
    };
  }
}
