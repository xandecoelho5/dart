import 'dart:async';
import 'dart:convert';

import 'package:backend/src/core/services/database/remote_database.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../core/services/bcrypt/bcrypt_service.dart';
import '../auth/guard/auth_guard.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/user', _getAllUser, middlewares: [AuthGuard()]),
        Route.get('/user/:id', _getUserById, middlewares: [AuthGuard()]),
        Route.post('/user', _createUser),
        Route.put('/user', _updateUser, middlewares: [AuthGuard()]),
        Route.delete('/user/:id', _deleteUser, middlewares: [AuthGuard()]),
      ];

  FutureOr<Response> _getAllUser(Injector injector) async {
    final database = injector.get<RemoteDatabase>();
    final result =
        await database.query('SELECT id, name, email, role FROM "User"');
    final userMap = result.map((e) => e['User']).toList();
    return Response.ok(jsonEncode(userMap));
  }

  FutureOr<Response> _getUserById(
    ModularArguments arguments,
    Injector injector,
  ) async {
    final id = arguments.params['id'];
    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
      'SELECT id, name, email, role FROM "User" WHERE id = @id',
      variables: {'id': id},
    );
    final userMap = result.map((element) => element['User']).first;
    return Response.ok(jsonEncode(userMap));
  }

  FutureOr<Response> _deleteUser(
    ModularArguments arguments,
    Injector injector,
  ) async {
    final id = arguments.params['id'];
    final database = injector.get<RemoteDatabase>();
    await database.query(
      'DELETE FROM "User" WHERE id = @id',
      variables: {'id': id},
    );
    return Response.ok(jsonEncode({'message': 'deleted $id'}));
  }

  FutureOr<Response> _createUser(
    ModularArguments arguments,
    Injector injector,
  ) async {
    final bcrypt = injector.get<BCryptService>();
    final database = injector.get<RemoteDatabase>();

    final userParams = arguments.data as Map<String, dynamic>;
    userParams['password'] = bcrypt.generateHash(userParams['password']);

    final result = await database.query(
      'INSERT INTO "User" (name, email, password) VALUES (@name, @email, @password) RETURNING id, name, email, role',
      variables: userParams,
    );
    final userMap = result.map((element) => element['User']).first;
    return Response.ok(jsonEncode(userMap));
  }

  FutureOr<Response> _updateUser(
    ModularArguments arguments,
    Injector injector,
  ) async {
    final userParams = arguments.data as Map<String, dynamic>;

    final columns = userParams.keys
        .where((key) => key != 'id' && key != 'password')
        .map((key) => '$key=@$key')
        .toList();

    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
      'UPDATE "User" set ${columns.join(',')} WHERE id = @id RETURNING id, name, email, role',
      variables: userParams,
    );
    final userMap = result.map((element) => element['User']).first;
    return Response.ok(jsonEncode(userMap));
  }
}
