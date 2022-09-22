import 'dart:convert';

import 'package:backend/src/core/services/request_extractor/request_extractor.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

main() {
  final extractor = RequestExtractor();

  test('getAuthorizationBearer', () async {
    final request = Request('get', Uri.parse('http://localhost/'), headers: {
      'authorization': 'Bearer jasidjasidjsadk2o13k12o',
    });
    final token = extractor.getAuthorizationBearer(request);
    expect(token, 'jasidjasidjsadk2o13k12o');
  });

  test('getAuthorizationBasic', () async {
    var credentialAuth = 'xd@mail.com:123';
    credentialAuth = base64Encode(credentialAuth.codeUnits);

    final request = Request('get', Uri.parse('http://localhost/'), headers: {
      'authorization': 'basic $credentialAuth',
    });

    final credential = extractor.getAuthorizationBasic(request);
    expect(credential.email, 'xd@mail.com');
    expect(credential.password, '123');
  });
}
