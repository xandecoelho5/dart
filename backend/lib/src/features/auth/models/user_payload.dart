class UserPayload {
  final int id;
  final String role;

  const UserPayload({required this.id, required this.role});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role': role,
    };
  }

  factory UserPayload.fromMap(Map<String, dynamic> map) {
    return UserPayload(
      id: map['id'] ?? 0,
      role: map['role'] ?? '',
    );
  }
}
