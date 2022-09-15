class User {
  const User({this.id, required this.username});

  final int? id;
  final String username;

  User copyWith({
    int? id,
    String? username,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
    );
  }
}
