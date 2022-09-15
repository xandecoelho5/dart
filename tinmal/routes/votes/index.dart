import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../adapters/vote_adapter.dart';
import '../../adapters/vote_param_adapter.dart';
import '../../datasource/in_memory_votes_data_source.dart';
import '../../models/vote.dart';
import '../../utils/globals.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  final dataSource = context.read<InMemoryVotesDataSource>();
  final votes = await dataSource.getVotes();
  return Response.json(body: votes.map(VoteAdapter.toMap).toList());
}

Future<Response> _post(RequestContext context) async {
  final dataSource = context.read<InMemoryVotesDataSource>();
  final voteParam = VoteParamAdapter.fromMap(await context.request.json());

  final userId = Globals.currentUser!.id!;
  print(userId);

  if (dataSource.alreadyVoted(voteParam.animalId, voteParam.voteType, userId)) {
    return Response(
      statusCode: HttpStatus.conflict,
      body: 'You already voted for this animal',
    );
  }

  final vote = Vote(
    liked: voteParam.liked,
    createdAt: DateTime.now().toIso8601String(),
    updatedAt: DateTime.now().toIso8601String(),
    voteType: voteParam.voteType,
    animalId: voteParam.animalId,
    userId: userId,
  );

  final addedVote = await dataSource.addVote(vote);

  return Response.json(
    statusCode: HttpStatus.created,
    body: VoteAdapter.toMap(addedVote),
  );
}
