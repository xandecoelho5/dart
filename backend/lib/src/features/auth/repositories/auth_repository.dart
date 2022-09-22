import 'package:backend/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:backend/src/core/services/jwt/jwt_service.dart';
import 'package:backend/src/core/services/request_extractor/request_extractor.dart';
import 'package:backend/src/features/auth/errors/errors.dart';
import 'package:backend/src/features/auth/models/tokenization.dart';

abstract class AuthDatasource {
  Future<Map> getIdAndRoleByEmail(String email);

  Future<String> getRoleById(dynamic id);

  Future<String> getPasswordById(dynamic id);

  Future<void> updatePasswordById(dynamic id, String password);
}

class AuthRepository {
  final BCryptService bcrypt;
  final JwtService jwt;
  final AuthDatasource datasource;

  AuthRepository(this.datasource, this.bcrypt, this.jwt);

  Future<Tokenization> login(LoginCredential credential) async {
    final userMap = await datasource.getIdAndRoleByEmail(credential.email);

    if (userMap.isEmpty) {
      throw AuthException(403, 'Email ou senha invalida');
    }

    if (!bcrypt.checkHash(credential.password, userMap['password'])) {
      throw AuthException(403, 'Email ou senha invalida');
    }

    final payload = userMap..remove('password');

    return _generateToken(payload);
  }

  Future<Tokenization> refreshToken(String token) async {
    final payload = jwt.getPayload(token);
    final role = datasource.getRoleById(payload['id']);
    return _generateToken({'id': payload['id'], 'role': role});
  }

  Future<void> updatePassword(
    String token,
    String password,
    String newPassword,
  ) async {
    final payload = jwt.getPayload(token);
    final hash = await datasource.getPasswordById(payload['id']);

    if (!bcrypt.checkHash(password, hash)) {
      throw AuthException(403, 'Senha invalida');
    }

    newPassword = bcrypt.generateHash(newPassword);
    await datasource.updatePasswordById(payload['id'], newPassword);
  }

  Tokenization _generateToken(Map payload) {
    payload['exp'] = _determineExpiration(Duration(minutes: 30));
    final accessToken = jwt.generateToken(payload, 'accessToken');
    payload['exp'] = _determineExpiration(Duration(days: 3));
    final refreshToken = jwt.generateToken(payload, 'refreshToken');

    return Tokenization(accessToken: accessToken, refreshToken: refreshToken);
  }

  int _determineExpiration(Duration duration) {
    final expiresDate = DateTime.now().add(duration);
    return expiresDate.difference(DateTime.now()).inSeconds;
  }
}
