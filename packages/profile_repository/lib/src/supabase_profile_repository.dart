import 'dart:io';
import 'dart:math';

import 'package:fpdart/fpdart.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:profile_repository/src/models/Profile_Error.dart';
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

  @override
  Future<void> updateDisplayName(String newDisplayName) async {
    await _appUserRepository.currentUser.match(
      () => throw Exception('No current user available'),
      (currentUser) async {
        await _supabase.client.from('profiles').upsert(
          {
            'id': currentUser.id,
            'display_name': newDisplayName,
          },
        );
      },
    );
  }

  @override
  Future<void> updateDob(DateTime newDob) async {
    try {
      await _appUserRepository.currentUser.match(
        () => throw Exception('No current user available'),
        (currentUser) async {
          await _supabase.client.from('profiles').upsert(
            {
              'id': currentUser.id,
              'dob': newDob.toIso8601String(),
            },
          );
        },
      );
    } catch (error) {
      throw Exception('Failed to update dob: $error');
    }
  }

  @override
  Future<void> updateGender(String gender) async {
    try {
      await _appUserRepository.currentUser.match(
        () => throw Exception('No current user available'),
        (currentUser) async {
          await _supabase.client.from('profiles').upsert(
            {
              'id': currentUser.id,
              'gender': gender,
            },
          );
        },
      );
    } catch (error) {
      throw Exception('Failed to update gender: $error');
    }
  }

  @override
  Future<String> uploadAvaImg({required File img}) async {
    try {
      String id = "";
      await _appUserRepository.currentUser.match(
        () => throw Exception('No current user available'),
        (currentUser) async {
          id = currentUser.id;
          await _supabase.client.storage.from('avata_img').upload(
              currentUser.id,
              img,
          );
          
        },
      );
    return _supabase.client.storage.from("avata_img").getPublicUrl(id); 
      
    } catch(e) {
      throw Exception('Failed to update img: $e');
    }
  }
  
  @override
  Future<void> updateAvata(File img) async {
   try {
      await _appUserRepository.currentUser.match(
        () => throw Exception('No current user available'),
        (currentUser) async {
          await _supabase.client.from('profiles').upsert(
            {
              'id': currentUser.id,
              'image_url': await uploadAvaImg(img: img),
            },
          );
        },
      );
    } catch (error) {
      throw Exception('Failed to update avatar user: $error');
    }
  }
  
  @override
Future<Option<Profile>> fetchProfile() async {
  try {
    return await _appUserRepository.currentUser.fold(
      () async => none(), // No current user available
      (currentUser) async {
        final response = await _supabase.client
            .from('profiles')
            .select()
            .eq('id', currentUser.id)
            .single();

        if (response.isEmpty) {
          return none();
        }
        return some(Profile.fromMap(response));
      },
    );
  } catch (error) {
    throw Exception('Failed to fetch profile: $error');
  }
}

  
  
}
