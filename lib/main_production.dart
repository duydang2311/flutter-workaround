import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cronet_http/cronet_http.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:location_client/location_client.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart';
import 'package:work_application_repository/work_application_repository.dart';
import 'package:work_repository/work_repository.dart';
import 'package:workaround/app/app.dart';
import 'package:workaround/bootstrap.dart';
import 'package:workaround/dart_define.gen.dart';

void main() {
  bootstrap(() {
    final supabase = Supabase.instance;
    final authenticationRepository = SupabaseAuthenticationRepository(
      supabase: supabase,
      supabaseRedirectUrl: 'io.supabase.flutterquickstart://login-callback/',
      webClientId: DartDefine.googleOauthWebClientId,
      iosClientId: DartDefine.googleOauthIosClientId,
    );
    final appUserRepository = SupabaseAppUserRepository(
      supabase: supabase,
    );
    final profileRepository = SupabaseProfileRepository(
      supabase: supabase,
      appUserRepository: appUserRepository,
    );
    final workRepository = SupabaseWorkRepository(supabase: supabase);
    Client httpClient;
    if (Platform.isAndroid) {
      final engine = CronetEngine.build(
        cacheMode: CacheMode.memory,
        cacheMaxSize: 2 * 1024 * 1024,
        userAgent: 'Workaround Agent',
      );
      httpClient = CronetClient.fromCronetEngine(engine, closeEngine: true);
    } else {
      httpClient = IOClient(HttpClient()..userAgent = 'Workaround Agent');
    }

    final locationClient = FusedLocationClient();
    final workApplicationRepository =
        SupabaseWorkApplicationRepository(client: supabase.client);

    return App(
      authenticationRepository: authenticationRepository,
      supabase: supabase,
      appUserRepository: appUserRepository,
      profileRepository: profileRepository,
      workRepository: workRepository,
      httpClient: httpClient,
      locationClient: locationClient,
      workApplicationRepository: workApplicationRepository,
    );
  });
}
