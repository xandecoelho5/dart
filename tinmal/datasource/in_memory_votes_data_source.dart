import '../models/vote.dart';
import '../models/vote_type.dart';

class InMemoryVotesDataSource {
  final _cache = <int, Vote>{};

  Future<Vote> addVote(Vote vote) async {
    final id = _cache.length + 1;
    final createdVote = vote.copyWith(id: id);
    _cache[id] = createdVote;
    return createdVote;
  }

  Future<List<Vote>> getVotes() async => _cache.values.toList();

  Future<Vote?> getVote(int id) async => _cache[id];

  Future<Vote> update(int id, Vote vote) async {
    return _cache.update(id, (value) => vote);
  }

  Future<void> delete(int id) async => _cache.remove(id);

  bool alreadyVoted(String animalId, VoteType voteType, int userId) {
    return _cache.values.any(
      (vote) =>
          vote.userId == userId &&
          vote.animalId == animalId &&
          vote.voteType == voteType,
    );
  }
}
