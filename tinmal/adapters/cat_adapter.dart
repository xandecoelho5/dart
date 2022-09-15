import '../models/cat.dart';

class CatAdapter {
  CatAdapter._();

  static Map<String, dynamic> toMap(Cat cat) {
    return {
      'id': cat.id,
      'name': cat.name,
      'path': cat.path,
    };
  }
}
