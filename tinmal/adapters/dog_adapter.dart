import '../models/dog.dart';

class DogAdapter {
  DogAdapter._();

  static Map<String, dynamic> toMap(Dog dog) {
    return {
      'id': dog.id,
      'name': dog.name,
      'path': dog.path,
    };
  }
}
