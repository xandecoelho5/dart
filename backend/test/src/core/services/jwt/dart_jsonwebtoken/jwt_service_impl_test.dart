import 'package:backend/src/core/services/dot_env/dot_env_service.dart';
import 'package:backend/src/core/services/jwt/dart_jsonwebtoken/jwt_service_impl.dart';
import 'package:test/test.dart';

main() {
  final dotEnvService = DotEnvService(mocks: {'JWT_KEY': 'secret'});
  final jwt = JwtServiceImpl(dotEnvService);

  test('jwt create', () async {
    final expiresDate = DateTime.now().add(Duration(seconds: 30));
    final expiresIn =
        Duration(milliseconds: expiresDate.millisecondsSinceEpoch).inSeconds;

    final token = jwt.generateToken({
      'id': 1,
      'role': 'user',
      'exp': expiresIn,
    }, 'accessToken');
    print(token);
  });

  test('jwt verify', () async {
    jwt.verifyToken(
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6InVzZXIiLCJleHAiOjE2NjM3ODksImlhdCI6MTY2Mzc4OTUwOSwiYXVkIjoiYWNjZXNzVG9rZW4ifQ.Ss6PuUvTRvmDotmIKuhyDhE_yz4Avqis2qDzHhFY4UA',
      'accessToken',
    );
  });

  test('jwt payload', () async {
    final payload = jwt.getPayload(
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6InVzZXIiLCJleHAiOjE2NjM3ODksImlhdCI6MTY2Mzc4OTUwOSwiYXVkIjoiYWNjZXNzVG9rZW4ifQ.Ss6PuUvTRvmDotmIKuhyDhE_yz4Avqis2qDzHhFY4UA',
    );
    print(payload);
  });
}
