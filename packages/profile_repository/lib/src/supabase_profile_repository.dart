import 'package:fpdart/fpdart.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart';

final class SupabaseProfileRepository implements ProfileRepository {
  const SupabaseProfileRepository({
    required Supabase supabase,
    required AppUserRepository appUserRepository,
  })  : _supabase = supabase,
        _appUserRepository = appUserRepository;

  final Supabase _supabase;
  final AppUserRepository _appUserRepository;

  @override
  Stream<Option<Profile>> get profile {
    return _appUserRepository.currentUserStream.asyncMap((option) async {
      print('_appUserRepository: $option');
      return option
          .toTaskOption()
          .flatMap(
            (t) => TaskOption.tryCatch(
              () => _supabase.client
                  .from('profiles')
                  .select()
                  .filter('id', 'eq', t.id)
                  .limit(1)
                  .single(),
            ),
          )
          .flatMap((data) => TaskOption.fromNullable(Profile.tryParse(data)))
          .run();
    });
  }
}
