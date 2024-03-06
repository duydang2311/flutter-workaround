import 'package:user_repository/user_repository.dart';

abstract class AppUserRepository {
  Stream<AppUser?> get user;
}
