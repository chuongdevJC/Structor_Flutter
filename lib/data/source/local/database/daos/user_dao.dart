import 'package:moor/moor.dart';
import 'package:structure_flutter/core/common/helpers/state_helper.dart';
import 'package:structure_flutter/data/models/user.dart';
import 'package:structure_flutter/data/source/local/database/entities/user_local_entity.dart';
import 'package:structure_flutter/data/source/remote/api/error/failures.dart';

import '../local_database.dart';

part 'user_dao.g.dart';

@UseDao(tables: [UserLocalEntities])
class UserDao extends DatabaseAccessor<LocalDatabase> with _$UserDaoMixin {
  UserDao(LocalDatabase attachedDatabase) : super(attachedDatabase);

  Future<State<List<User>, Failures>> getAllUsers() async {
    try {
      final data = await select(userLocalEntity)
          .map((userDB) => User.copyWithLocal(userDB))
          .get();
      return State.success(data);
    } catch (e) {
      final UnhandledFailure failure = UnhandledFailure(e.toString());
      return State.error(failure);
    }
  }

  Stream<List<User>> get allUsersStream => select(userLocalEntity)
      .map((userDB) => User.copyWithLocal(userDB))
      .watch();

  Future<dynamic> insertUsers(List<User> users) {
    var userEntities = users
        .map((user) => UserLocalEntityCompanion.insert(
            id: Value(user.id), name: user.name, avatar: user.avatar))
        .toList();
    return batch((batch) {
      batch.insertAllOnConflictUpdate(userLocalEntity, userEntities);
    });
  }
}
