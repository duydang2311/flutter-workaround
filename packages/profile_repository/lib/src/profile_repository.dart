import 'package:fpdart/fpdart.dart';
import 'package:profile_repository/profile_repository.dart';

abstract interface class ProfileRepository {
  Stream<Option<Profile>> get profile;
}
