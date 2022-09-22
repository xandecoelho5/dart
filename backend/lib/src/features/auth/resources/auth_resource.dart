import 'dart:async';
import 'dart:convert';

import 'package:backend/src/core/services/request_extractor/request_extractor.dart';
import 'package:backend/src/features/auth/errors/errors.dart';
import 'package:backend/src/features/auth/guard/auth_guard.dart';
import 'package:backend/src/features/auth/repositories/auth_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/login', _login),
        Route.get('/refresh_token', _refreshToken, middlewares: [
          AuthGuard(isRefreshToken: true),
        ]),
        Route.get('/check_token', _checkToken, middlewares: [AuthGuard()]),
        Route.put('/update_password', _updatePassword),
      ];

  FutureOr<Response> _login(Request request, Injector injector) async {
    final authRepository = injector.get<AuthRepository>();
    final extractor = injector.get<RequestExtractor>();
    final credential = extractor.getAuthorizationBasic(request);

    try {
      final tokenization = await authRepository.login(credential);
      return Response.ok(tokenization.toJson());
    } on AuthException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  FutureOr<Response> _refreshToken(Request request, Injector injector) async {
    final extractor = injector.get<RequestExtractor>();
    final authRepository = injector.get<AuthRepository>();

    final token = extractor.getAuthorizationBearer(request);

    final tokenization = await authRepository.refreshToken(token);
    return Response.ok(tokenization.toJson());
  }

  FutureOr<Response> _checkToken() {
    return Response.ok(jsonEncode({'message': 'OK'}));
  }

  FutureOr<Response> _updatePassword(
    Request request,
    Injector injector,
    ModularArguments arguments,
  ) async {
    final extractor = injector.get<RequestExtractor>();
    final authRepository = injector.get<AuthRepository>();
    final data = arguments.data as Map;

    final token = extractor.getAuthorizationBearer(request);

    try {
      await authRepository.updatePassword(
        token,
        data['password'],
        data['newPassword'],
      );
    } on AuthException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }

    return Response.ok(jsonEncode({'message': 'Senha atualizada'}));
  }
}
