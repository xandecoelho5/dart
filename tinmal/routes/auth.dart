import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../adapters/user_adapter.dart';
import '../datasource/in_memory_users_data_source.dart';
import '../utils/constants.dart';

FutureOr<Response> onRequest(RequestContext context) {
  if (context.request.method == HttpMethod.post) return _post(context);

  return Response(statusCode: HttpStatus.methodNotAllowed);
}

Future<Response> _post(RequestContext context) async {
  final user = UserAdapter.fromMap(await context.request.json());

  final dataSource = context.read<InMemoryUsersDataSource>();
  final savedUser = await dataSource.saveUser(user);

  final jwt = JWT(UserAdapter.toMap(savedUser), issuer: kJWTIssuer);
  final token = jwt.sign(SecretKey(kJWTSecret));

  return Response.json(body: 'Bearer $token');
}
