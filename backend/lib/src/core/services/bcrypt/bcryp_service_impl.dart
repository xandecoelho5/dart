import 'package:bcrypt/bcrypt.dart';

import 'bcrypt_service.dart';

class BCryptServiceImpl implements BCryptService {
  @override
  bool checkHash(String text, String hash) {
    return BCrypt.checkpw(text, hash);
  }

  @override
  String generateHash(String text) {
    return BCrypt.hashpw(text, BCrypt.gensalt());
  }
}
