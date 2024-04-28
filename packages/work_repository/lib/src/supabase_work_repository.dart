import 'dart:async';
import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:shared_kernel/shared_kernel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:work_repository/src/models/nearby_work.dart';
import 'package:work_repository/work_repository.dart';

final class SupabaseWorkRepository implements WorkRepository {
  SupabaseWorkRepository({required Supabase supabase}) : _supabase = supabase {
    _streamController = new StreamController<PostgresChangePayload>.broadcast(
      onListen: _handleStreamListen,
      onCancel: _handleStreamCancel,
    );
  }

  final Supabase _supabase;
  late final StreamController<PostgresChangePayload> _streamController;
  late final RealtimeChannel _insertRealtimeChannel;

  @override
  Stream<PostgresChangePayload> get stream => _streamController.stream;

  @override
  TaskEither<SaveWorkError, void> insertWork(Work work) {
    return TaskEither.tryCatch(
      () => _supabase.client.from('works').insert({
        'owner_id': work.ownerId,
        'title': work.title,
        'description': work.description,
        'place_id': work.placeId,
        'location': 'point(${work.lng} ${work.lat})',
      }),
      _catch,
    );
  }

  @override
  TaskEither<GenericError, List<NearbyWork>> getNearbyWorks(
    double lat,
    double lng, {
    double? kmRadius,
    int? limit,
  }) {
    return TaskEither.tryCatch(
      () => _supabase.client.rpc<dynamic>(
        'works_get_nearby',
        params: {
          'lat': lat,
          'lng': lng,
          'radius': (kmRadius ?? 10) * 1000,
          'max_rows': limit ?? 10,
        },
      ),
      _catchGenericError,
    ).map(
      (r) => (r as List).map((e) {
        final json = e as Map<String, dynamic>;
        return NearbyWork(
          id: json['id'] as String,
          title: json['title'] as String,
          lat: json['lat'] as double,
          lng: json['lng'] as double,
          distance: json['distance'] as double,
        );
      }).toList(),
    );
  }

  SaveWorkError _catch(Object error, StackTrace stackTrace) {
    switch (error) {
      case final AuthException e:
        return SaveWorkError.fromException(e);
      case final Exception e:
        return SaveWorkError.fromException(e);
      default:
        return const SaveWorkError.unknown();
    }
  }

  GenericError _catchGenericError(Object error, StackTrace stackTrace) {
    return switch (error) {
      final AuthException e => GenericError.fromAuthException(e),
      final Exception e => GenericError.fromException(e),
      _ => const GenericError.unknown()
    };
  }

  void _handleStreamListen() {
    log('_handleStreamListen');
    _insertRealtimeChannel = _supabase.client
        .channel('works')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'works',
            callback: _handleStream)
        .subscribe((status, object) {
      log('[SupabaseWorkRepository] _handleStreamListen: $status, $object');
    });
  }

  void _handleStreamCancel() {
    TaskEither.tryCatch(_insertRealtimeChannel.unsubscribe, (error, _) => error)
        .match((l) {
      log('[SupabaseWorkRepository] _handleStreamCancel: $l');
    }, (r) {
      log('[SupabaseWorkRepository] _handleStreamCancel: ok');
    }).run();
  }

  void _handleStream(PostgresChangePayload payload) {
    _streamController.sink.add(payload);
    log('[SupabaseWorkRepository] _handleStream: $payload');
  }
}
