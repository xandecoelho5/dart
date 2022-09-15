import 'vote_type.dart';

class VoteParam {
  const VoteParam({
    required this.voteType,
    required this.animalId,
    required this.liked,
  });

  final VoteType voteType;
  final String animalId;
  final bool liked;
}
