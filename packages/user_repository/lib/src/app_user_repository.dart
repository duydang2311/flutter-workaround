import 'package:fpdart/fpdart.dart';
import 'package:user_repository/user_repository.dart';

abstract class AppUserRepository {
  Stream<Option<AppUser>> get user;
}
