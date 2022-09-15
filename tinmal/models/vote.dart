import 'vote_type.dart';

class Vote {
  const Vote({
    this.id,
    required this.userId,
    required this.voteType,
    required this.animalId,
    required this.liked,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int userId;
  final VoteType voteType;
  final String animalId;
  final bool liked;
  final String createdAt;
  final String updatedAt;

  Vote copyWith({
    int? id,
    int? userId,
    VoteType? voteType,
    String? animalId,
    bool? liked,
    String? createdAt,
    String? updatedAt,
  }) {
    return Vote(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      voteType: voteType ?? this.voteType,
      animalId: animalId ?? this.animalId,
      liked: liked ?? this.liked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
