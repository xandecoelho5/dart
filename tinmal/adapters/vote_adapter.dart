import '../models/vote.dart';
import '../models/vote_type.dart';

class VoteAdapter {
  VoteAdapter._();

  static Vote fromMap(Map<String, dynamic> map) {
    return Vote(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      voteType: map['vote_type'] as VoteType,
      animalId: map['animal_id'] as String,
      liked: map['liked'] as bool,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
    );
  }

  static Map<String, dynamic> toMap(Vote vote) {
    return {
      'id': vote.id,
      'user_id': vote.userId,
      'vote_type': vote.voteType.name,
      'animal_id': vote.animalId,
      'liked': vote.liked,
      'created_at': vote.createdAt,
      'updated_at': vote.updatedAt,
    };
  }
}
