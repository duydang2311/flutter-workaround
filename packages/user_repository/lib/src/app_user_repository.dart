import 'package:fpdart/fpdart.dart';
import 'package:user_repository/src/models/get_user_error.dart';
import 'package:user_repository/user_repository.dart';

abstract interface class AppUserRepository {
  Option<AppUser> get currentUser;
  Stream<Option<AppUser>> get currentUserStream;
  TaskEither<GetUserError, AppUser> getUser();
}
