import 'package:backend/src/core/services/database/remote_database.dart';
import 'package:backend/src/features/auth/repositories/auth_repository.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final RemoteDatabase database;

  AuthDatasourceImpl(this.database);

  @override
  Future<Map> getIdAndRoleByEmail(String email) async {
    final result = await database.query(
      'SELECT id, role, password FROM "User" WHERE email = @email',
      variables: {'email': email},
    );

    if (result.isEmpty) return {};

    return result.map((e) => e['User']).first!;
  }

  @override
  Future<String> getRoleById(dynamic id) async {
    final result = await database.query(
      'SELECT role FROM "User" WHERE id = @id',
      variables: {'id': id},
    );

    return result.map((e) => e['User']).first!['role'];
  }

  @override
  Future<String> getPasswordById(id) async {
    final result = await database.query(
      'SELECT password FROM "User" WHERE id = @id',
      variables: {'id': id},
    );
    return result.map((e) => e['User']).first!['password'];
  }

  @override
  Future<void> updatePasswordById(id, String password) async {
    await database.query(
      'UPDATE "User" SET password = @password WHERE id = @id;',
      variables: {'id': id, 'password': password},
    );
  }
}
