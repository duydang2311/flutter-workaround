import 'dart:io';

import 'package:flutter/src/widgets/framework.dart';
import 'package:fpdart/fpdart.dart';
import 'package:profile_repository/profile_repository.dart';

abstract interface class ProfileRepository {
  ProfileRepository(BuildContext context);

  Stream<Option<Profile>> get profile;

  Future<void> updateDisplayName(String newDisplayName);

  Future<void> updateDob(DateTime newDob);

  Future<void> updateGender(String gender);
  Future<void> updateAvata(File img);
  Future<String> uploadAvaImg({
    required File img,
  });
}
