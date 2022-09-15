import '../models/vote_param.dart';
import '../models/vote_type.dart';

class VoteParamAdapter {
  VoteParamAdapter._();

  static VoteParam fromMap(Map<String, dynamic> map) {
    return VoteParam(
      voteType: VoteType.values.where((e) => e.name == map['vote_type']).first,
      animalId: map['animal_id'] as String,
      liked: map['liked'] as bool,
    );
  }
}
