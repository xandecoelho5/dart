import 'dart:convert';

import 'package:shelf/shelf.dart';

class RequestExtractor {
  String getAuthorizationBearer(Request request) {
    var authorization = request.headers['authorization'] ?? '';
    authorization = authorization.split(' ').last;
    return authorization;
  }

  LoginCredential getAuthorizationBasic(Request request) {
    // username:password < base64
    var authorization = request.headers['authorization'] ?? '';
    authorization = authorization.split(' ').last;
    authorization = String.fromCharCodes(base64Decode(authorization));

    final credentials = authorization.split(':');
    return LoginCredential(
      email: credentials.first,
      password: credentials.last,
    );
  }
}

class LoginCredential {
  final String email;
  final String password;

  LoginCredential({required this.email, required this.password});
}
