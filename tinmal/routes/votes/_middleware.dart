import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../../adapters/user_adapter.dart';
import '../../utils/constants.dart';
import '../../utils/globals.dart';

Handler middleware(Handler handler) {
  return (context) async {
    final auth = context.request.headers['authorization'];
    if (auth == null) {
      return Response(
        statusCode: HttpStatus.unauthorized,
        body: 'Access token is missing or invalid',
      );
    }

    if (!auth.contains('Bearer')) {
      return Response(
        statusCode: HttpStatus.unauthorized,
        body: 'Authorization header must be Bearer',
      );
    }

    try {
      final token = auth.split(' ').last;
      final jwt = JWT.verify(token, SecretKey(kJWTSecret));

      Globals.currentUser =
          UserAdapter.fromMap(jwt.payload as Map<String, dynamic>);
    } catch (e) {
      print(e);
      return Response(
        statusCode: HttpStatus.unauthorized,
        body: 'Access token is missing or invalid',
      );
    }

    return await handler(context);
  };
}
