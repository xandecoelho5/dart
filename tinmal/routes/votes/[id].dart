import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../adapters/vote_adapter.dart';
import '../../adapters/vote_param_adapter.dart';
import '../../datasource/in_memory_votes_data_source.dart';
import '../../models/vote.dart';

FutureOr<Response> onRequest(RequestContext context, String id) async {
  final dataSource = context.read<InMemoryVotesDataSource>();
  final vote = await dataSource.getVote(int.parse(id));

  if (vote == null) {
    return Response(statusCode: HttpStatus.notFound, body: 'Not found');
  }

  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, vote);
    case HttpMethod.delete:
      return _delete(context, id);
    case HttpMethod.put:
      return _put(context, id, vote);
    case HttpMethod.post:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, Vote vote) async {
  return Response.json(body: VoteAdapter.toMap(vote));
}

Future<Response> _put(RequestContext context, String id, Vote vote) async {
  final dataSource = context.read<InMemoryVotesDataSource>();
  final voteParam = VoteParamAdapter.fromMap(await context.request.json());
  final newVote = await dataSource.update(
    int.parse(id),
    vote.copyWith(
      liked: voteParam.liked,
      updatedAt: DateTime.now().toIso8601String(),
      voteType: voteParam.voteType,
      animalId: voteParam.animalId,
    ),
  );

  return Response.json(body: VoteAdapter.toMap(newVote));
}

Future<Response> _delete(RequestContext context, String id) async {
  final dataSource = context.read<InMemoryVotesDataSource>();
  await dataSource.delete(int.parse(id));
  return Response(statusCode: HttpStatus.noContent);
}
