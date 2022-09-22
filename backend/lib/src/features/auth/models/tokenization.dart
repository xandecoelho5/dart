import 'dart:convert';

class Tokenization {
  final String accessToken;
  final String refreshToken;

  const Tokenization({
    required this.accessToken,
    required this.refreshToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  factory Tokenization.fromMap(Map<String, dynamic> map) {
    return Tokenization(
      accessToken: map['access_token'] as String,
      refreshToken: map['refresh_token'] as String,
    );
  }

  String toJson() => json.encode(toMap());
}
