import 'package:dart_frog/dart_frog.dart';

import '../adapters/dog_adapter.dart';
import '../mocks/dogs_mock.dart';

Response onRequest(RequestContext context) {
  return Response.json(
    body: dogsMock.map(DogAdapter.toMap).toList(),
  );
}
