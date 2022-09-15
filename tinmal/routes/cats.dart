import 'package:dart_frog/dart_frog.dart';

import '../adapters/cat_adapter.dart';
import '../mocks/cats_mock.dart';

Response onRequest(RequestContext context) {
  return Response.json(
    body: catsMock.map(CatAdapter.toMap).toList(),
  );
}
