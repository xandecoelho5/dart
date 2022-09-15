import 'package:dart_frog/dart_frog.dart';

import '../datasource/in_memory_users_data_source.dart';
import '../datasource/in_memory_votes_data_source.dart';

final _votesDataSource = InMemoryVotesDataSource();
final _usersDataSource = InMemoryUsersDataSource();

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<InMemoryVotesDataSource>((_) => _votesDataSource))
      .use(provider<InMemoryUsersDataSource>((_) => _usersDataSource));
}
