import 'dart:async';
import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:shared_kernel/shared_kernel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:work_repository/work_repository.dart';

final class SupabaseWorkRepository implements WorkRepository {
  SupabaseWorkRepository({required Supabase supabase}) : _supabase = supabase {
    _streamController = StreamController<PostgresChangePayload>.broadcast(
      onListen: _handleStreamListen,
      onCancel: _handleStreamCancel,
    );
  }

  final Supabase _supabase;
  late final StreamController<PostgresChangePayload> _streamController;
  RealtimeChannel? _insertRealtimeChannel;

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
        'address': work.address,
        'status': WorkStatus.closed.name,
      }),
      _catch,
    );
  }

  @override
  TaskEither<GenericError, dynamic> update(
    Map<String, dynamic> values, {
    String? id,
    String? columns,
  }) {
    PostgrestTransformBuilder<dynamic> builder =
        _supabase.client.from('works').update(values).match({
      if (id != null) 'id': id,
    });
    if (columns != null) {
      builder = builder.select(columns);
    }
    return TaskEither.tryCatch(
      () => builder,
      _catchGenericError,
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
          'from_lat': lat,
          'from_lng': lng,
          if (kmRadius != null) 'radius': kmRadius * 1000,
          'max_rows': limit ?? 10,
        },
      ),
      _catchGenericError,
    ).map(
      (r) => (r as List).map((e) {
        final json = e as Map<String, dynamic>;
        return NearbyWork(
          id: json['id'] as String,
          createdAt: DateTime.parse(json['created_at'] as String),
          ownerName: json['owner_name'] as String,
          title: json['title'] as String,
          address: json['address'] as String,
          lat: json['lat'] as double,
          lng: json['lng'] as double,
          distance: json['distance'] as double,
          status: WorkStatus.values.byName(json['status'] as String),
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
      final PostgrestException e => GenericError.fromPostgrestException(e),
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
          callback: _handleStream,
        )
        .subscribe((status, object) {
      log('[SupabaseWorkRepository] _handleStreamListen: $status, $object');
    });
  }

  void _handleStreamCancel() {
    TaskEither.tryCatch(
      _insertRealtimeChannel!.unsubscribe,
      (error, _) => error,
    ).match((l) {
      _insertRealtimeChannel = null;
      log('[SupabaseWorkRepository] _handleStreamCancel: $l');
    }, (r) {
      log('[SupabaseWorkRepository] _handleStreamCancel: ok');
    }).run();
  }

  void _handleStream(PostgresChangePayload payload) {
    _streamController.sink.add(payload);
    log('[SupabaseWorkRepository] _handleStream: $payload');
  }

  @override
  TaskEither<GenericError, Map<String, dynamic>> getWorkById(
    String id, {
    String columns = '*',
  }) {
    return TaskEither.tryCatch(
      () => _supabase.client
          .from('works')
          .select(columns)
          .eq('id', id)
          .limit(1)
          .maybeSingle(),
      _catchGenericError,
    ).flatMap(
      (r) => TaskEither.fromNullable(
        r,
        () => const GenericError(
          message: 'Unable to find work.',
          code: 'not_found',
        ),
      ),
    );
  }

  @override
  TaskEither<GenericError, List<Map<String, dynamic>>> getWorks({
    String? from,
    String columns = '*',
    RowRange? range,
    ColumnOrder? order,
    Map<String, dynamic>? match,
    FullTextSearch? fullTextSearch,
  }) {
    PostgrestTransformBuilder<List<Map<String, dynamic>>> builder = _supabase
        .client
        .from(from ?? 'works')
        .select(columns)
        .match(match ?? {});
    if (fullTextSearch != null) {
      builder = (builder as PostgrestFilterBuilder<List<Map<String, dynamic>>>)
          .textSearch(fullTextSearch.column, fullTextSearch.query);
    }
    if (order != null) {
      builder = builder.order(
        order.column,
        ascending: order.ascending,
        nullsFirst: order.nullsFirst,
        referencedTable: order.referencedTable,
      );
    }
    if (range != null) {
      builder = builder.range(
        range.from,
        range.to,
        referencedTable: range.referencedTable,
      );
    }
    return TaskEither.tryCatch(
      () => builder,
      _catchGenericError,
    );
  }

  @override
  TaskEither<GenericError, List<NearbyWorkWithDescription>>
      getNearbyWorksWithDescription(
    double lat,
    double lng, {
    double? kmRadius,
    int? limit,
    int descriptionLength = 80,
    String? ownerId,
    int? offset,
  }) {
    return TaskEither.tryCatch(
      () => _supabase.client.rpc<dynamic>(
        'works_get_nearby_with_desc',
        params: {
          'from_lat': lat,
          'from_lng': lng,
          if (kmRadius != null) 'radius': kmRadius * 1000,
          'max_rows': limit ?? 10,
          'description_length': descriptionLength,
          if (ownerId != null) 'owner_id': ownerId,
          'skipped_rows': offset ?? 0,
        },
      ),
      _catchGenericError,
    ).map(
      (r) => (r as List).map((e) {
        final json = e as Map<String, dynamic>;
        return NearbyWorkWithDescription(
          id: json['id'] as String,
          createdAt: DateTime.parse(json['created_at'] as String),
          ownerName: json['owner_name'] as String,
          title: json['title'] as String,
          address: json['address'] as String,
          lat: json['lat'] as double,
          lng: json['lng'] as double,
          distance: json['distance'] as double,
          description: json['description'] as String?,
          status: WorkStatus.values.byName(json['status'] as String),
        );
      }).toList(),
    );
  }
}
